'use strict';

var _ = require('lodash');
var Result = require('./result.model');
var User = require('../user/user.model');
var Form = require('../form/form.model');
var fs = require('fs');
var pdf = require('html-pdf');
var path = require('path');
var NodePDF = require('nodepdf');
var map = require('map-stream');
var csv = require('csv');
var json2csv = require('json2csv');

var prepareDate = function(data) {
  var choice, field, form, i, ref, response, secField, secFieldIndex, section, results;

  form = data.form;
  ref = data.results;
  results = [];

  for (i = 0; i < ref.length; i++) {

    field = ref[i];
    results[i] = {};

    section = _.findIndex(form.sections, function(s) {
        return s.id === field.section_id;
      });

    secFieldIndex = _.findIndex(form.sections[section].fields, function(s) {
        return s.id === field.field_id;
      });

    secField = data.form.sections[section].fields[secFieldIndex];

    results[i].question = secField.label;
    results[i].section_index = section;
    results[i].section_title = data.form.sections[section].title;
    results[i].sequence = secField.sequence;
    results[i].possible_points = field.possible_points;
    results[i].aquired_points = field.aquired_points;

    if (field.field_type === 'text' || field.field_type === 'textarea') {
      results[i].response = field.response || '';
    } else if (field.field_type === 'radiobutton' || field.field_type === 'select') {
      choice = _.findIndex(secField.choices, function(s) {
          return s.id === field.response;
        });
      if (choice > -1) {
        results[i].response = secField.choices[choice].label;
      }
    } else if (field.field_type === 'checkbox' && field.response) {
      response = [];
      field.response.forEach(function(val) {
          choice = _.find(secField.choices, function(s) {
            return s.id === val;
          });
          if (choice) {
            return response.push(choice.label);
          }
        });
      results[i].response = response.join(', ');
    }
  }

  var sortedResult = _.sortBy(results, ['section_index', 'sequence']);

  sortedResult.unshift({
      question: 'Submitted at',
      response: data.updated
    });

  sortedResult.unshift({
      question: 'Submitted by',
      response: data.user_info.username
    });

  return sortedResult;

};

// Get list of results
exports.index = function(req, res) {
  Result.find(function(err, results) {
    if (err) { return handleError(res, err); }
    return res.json(200, results);
  });
};

// Get a single result
exports.show = function(req, res) {
  Result.find({
    _id: req.params.id
  }).populate('certificate').exec(function(err, result) {
    if (err) { return handleError(res, err); }
    if (result.length == 0) {
      return res.status(404).json(result);
    }
    return res.status(200).json(result);
  });
};

exports.showallresults = function(req, res) {
  Result.find({
    form: req.params.id
  })
  .lean()
  .populate('form')
  .exec(function(err, result) {
    if (err) { return handleError(res, err); }
    if (!result) { return res.send(404); }
    return res.json(result);
  });
};

exports.submissions = function(req, res) {
  Result.find({
    user: req.user._id
  }).lean().populate('form')
  .exec(function(err, result) {
    if (err) { return handleError(res, err); }
    if (!result) { return res.send(404); }
    return res.json(result);
  });
};

// Creates a new result in the DB.
exports.create = function(req, res) {
  Result.create(req.body, function(err, result) {
    if (err) { return handleError(res, err); }
    return res.json(201, result);
  });
};

exports.getpdf = function(req, res) {

};

exports.getCSV = function(req, res) {

  var resId = req.params.id,
    newData;

  Result.findById(resId).deepPopulate('form.sections.fields.choices').exec(function(err, data) {
    newData = prepareDate(data);
    var fields = ['section_index', 'section_title', 'sequence', 'question', 'response'];
    json2csv({data: newData, fields: fields}, function(err, csv) {
      if (err) console.log(err);
      fs.writeFile(__dirname + '/../../exported-files/' + data.id + '.csv', csv, function(err) {
        if (err) throw err;
        return res.status(200).json('exports/' + data.id + '.csv');
      });
    });
  });
};

// Updates an existing result in the DB.
exports.update = function(req, res) {
  var formId = req.body.form,
      userId = req.user.id,
      resultId = req.body.results_id,
      submitted = req.body.submitted;

  var result = {
    user: userId,
    user_info: {
      username: req.user.name,
      email: req.user.email
    },
    form: formId,
    updated: Date.now(),
    submitted: req.body.submitted,
    points: req.body.points,
    total_points: req.body.total_points,
    results: req.body.results,
    sections: req.body.sections,
    status: req.body.submitted ? 'submitted' : 'draft'
  };

  if (submitted == true) {
    Form.findById(formId).populate('certificates').exec(function(err, resultedForm) {
      var certificate = null;
      var perPoints = (req.body.points * 100) / req.body.total_points;
      resultedForm.certificates.forEach(function(value) {
        if (perPoints <= value.max && perPoints >= value.min)
          certificate = value._id;
      });
      result.certificate = certificate;
      result.expires = _getDate(resultedForm.expires_in.number, resultedForm.expires_in.unit);
      _updateResults();
    });
  } else {
    _updateResults();
  }

  function _getDate(number, unit) {
    var now = new Date();
    switch (unit) {
      case 'years':
        now.setUTCFullYear(now.getUTCFullYear() + number);
        break;
      case 'months':
        now.setUTCMonth(now.getUTCMonth() + number);
        break;
      case 'days':
        now.setUTCDate(now.getUTCDate() + number);
        break;
      case 'hours':
        now.setUTCHours(now.getUTCHours() + number);
        break;
      case 'minutes':
        now.setUTCMinutes(now.getUTCMinutes() + number);
        break;
      case 'seconds':
        now.setUTCSeconds(now.getUTCSeconds() + number);
        break;
      default:
        return null;
    }
    return now;
  }

  function _updateResults() {
    if (resultId == undefined) {
      Result.create(result, function(err, createdItem) {
        if (err) { return handleError(res, err); }
        if (submitted == true) {
          Form.findById(formId).populate('certificates').exec(function(err, resultedForm) {
            return res.json(201, createdItem);
          });
        } else {
          return res.json(201, createdItem);
        }
      });
    } else {
      Result.update({
        _id: resultId
      }, result).exec(function(err, resl) {
        if (err) { return handleError(resl, err); }
        result._id = resultId;
        return res.status(201).json(result);
      });
    }
  }

};

// Deletes a result from the DB.
exports.destroy = function(req, res) {
  Result.findById(req.params.id, function(err, result) {
    if (err) { return handleError(res, err); }
    if (!result) { return res.send(404); }
    result.remove(function(err) {
      if (err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
