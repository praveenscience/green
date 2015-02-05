'use strict';

var _ = require('lodash');
var Result = require('./result.model');
var User = require('../user/user.model');
var Form = require('../form/form.model');

// Get list of results
exports.index = function(req, res) {
  Result.find(function (err, results) {
    if(err) { return handleError(res, err); }
    return res.json(200, results);
  });
};

// Get a single result
exports.show = function(req, res) {
  Result.find({
    _id: req.params.id
  }).populate('certificate').exec(function(err, result) {
    if(err) { return handleError(res, err); }
    if(!result) { return res.send(404); }
    return res.json(result);
  })
};

exports.showresponses = function(req, res) {
  var formId = req.params.id;
  var resId = req.params.res;



  return res.json({message: "true"});
}

exports.showallresults = function(req, res) {
  Result.find({
    form: req.params.id
  })
  .lean()
  .populate('form')
  .exec(function(err, result) {
    if(err) { return handleError(res, err); }
    if(!result) { return res.send(404); }
    return res.json(result);
  });
}

exports.submissions = function(req, res) {
  Result.find({
    user: req.user._id
  }).lean().populate('form')
  .exec(function(err, result) {
    if(err) { return handleError(res, err); }
    if(!result) { return res.send(404); }
    return res.json(result);
  });
}


// Creates a new result in the DB.
exports.create = function(req, res) {
  Result.create(req.body, function(err, result) {
    if(err) { return handleError(res, err); }
    return res.json(201, result);
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
    results: req.body.results
  }


  if(submitted == true) {
    Form.findById(formId).populate('certificates').exec(function(err, resultedForm){
      var certificate = null;
      var perPoints = (req.body.points * 100) / req.body.total_points
      resultedForm.certificates.forEach(function(value) {
        if(perPoints <= value.max && perPoints >= value.min)
          certificate = value._id;
      })
      result.certificate = certificate;
      _updateResults();
    })
  }
  else {
    _updateResults();
  }


  function _updateResults() {
    if(resultId == undefined) {
      Result.create(result, function(err, createdItem) {
        if(err) { return handleError(res, err); }
        if(submitted == true) {
          Form.findById(formId).populate('certificates').exec(function(err, resultedForm){
            console.log(resultedForm.certificates);
            return res.json(201, createdItem);
          })
        } else {
          return res.json(201, createdItem);
        }
      });
    }
    else {
      Result.update({
        _id: resultId
      }, result).exec(function(err, resl){
        if (err) { return handleError(resl, err); }
        result._id = resultId;
        return res.json(201, result);
      });
    }
  }

};

// Deletes a result from the DB.
exports.destroy = function(req, res) {
  Result.findById(req.params.id, function (err, result) {
    if(err) { return handleError(res, err); }
    if(!result) { return res.send(404); }
    result.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
