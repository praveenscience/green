'use strict';

var _ = require('lodash');
var Section = require('./section.model');
var Field = require('../field/field.model');
var Choice = require('../choice/choice.model');
var async = require('async');
var mongoose = require('mongoose');
var marked = require('marked');
var renderer = new marked.Renderer();

renderer.link = function (href, title, text) {
  return '<a target="_blank" href="' + href + '" title="'+ title +'">' + text + '</a>';
}

// Get list of sections
exports.index = function(req, res) {
  Section.find(function(err, sections) {
    if (err) {
      return handleError(res, err);
    }
    return res.json(200, sections);
  });
};

// Get a single section
exports.show = function(req, res) {
  Section.findById(req.params.id)
    .populate('fields')
    .exec(function(err, section) {
      if (err) {
        return handleError(res, err);
      }
      if (!section) {
        return res.send(404);
      }
      return res.json(section);
    });
};

// Creates a new section in the DB.
exports.create = function(req, res) {
  Section.create(req.body, function(err, section) {
    if (err) {
      return handleError(res, err);
    }
    return res.json(201, section);
  });
};

// Updates an existing section in the DB.
exports.update = function(req, res) {
  if (req.body._id) {
    delete req.body._id;
  }
  Section.findById(req.params.id, function(err, section) {
    if (err) {
      return handleError(res, err);
    }
    if (!section) {
      return res.send(404);
    }
    var updated = _.merge(section, req.body);
    updated.save(function(err) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, section);
    });
  });
};

exports.updatefields = function(req, res) {
  if (req.body._id) {
    delete req.body._id;
  }
  Section.findById(req.params.id, function(err, section) {
    if (err) {
      return handleError(res, err);
    }
    if (!section) {
      return res.send(404);
    }

    var newSection = req.body;

    section.title = newSection.title;
    section.possible_points = newSection.possible_points;
    section.bonus_points = newSection.bonus_points;

    var _updateFields = function(callback) {
      var fields = req.body.fields
      var fieldsArray = []
      async.each(fields, function(field, callbackFields){
        var choicesArray = []
        async.each(field.choices, function(choice, callbackOpitons) {
          var choiceId = choice._id || mongoose.Types.ObjectId();
          delete choice._id;
          if(choice.help_text != undefined) {
            choice.help_text_html = marked(choice.help_text, { renderer: renderer });
          }
          Choice.update({
              _id: choiceId
            }, choice, {
              upsert: true
            })
            .exec(function(err, choiceN) {
              choicesArray.push(choiceId);
              callbackOpitons();
            });
        }, function(err){
          field.choices = []
          field.choices = choicesArray
          var fieldId = field._id || mongoose.Types.ObjectId();
          delete field._id
          Field.update({
              _id: fieldId
            }, field, {
              upsert: true
            })
            .exec(function(err, fieldN) {
              fieldsArray.push(fieldId);
              callbackFields();
            });
          });

      }, function(err) {
        callback(null, fieldsArray);
      })
    }

    var _updateSection = function(fieldsArr, callbackSections) {
      section.fields = []
      section.fields = fieldsArr
      section.updated = Date.now()
      section.save(function(err) {
        if (err) {
          return handleError(res, err);
        }
        callbackSections(null, section)
      });
    }

    async.waterfall([
      _updateFields,
      _updateSection
    ], function(err, section) {
      Section.populate(section, {
        path: 'fields',
        model: Field
      }, function(err, formFields) {
        Choice.populate(formFields, {
          path: 'fields.choices',
          model: Choice
        }, function(err, formOptions) {
          return res.json(200, formOptions);
        })
      })
    })
  });
};

// Deletes a section from the DB.
exports.destroy = function(req, res) {
  Section.findById(req.params.id, function(err, section) {
    if (err) {
      return handleError(res, err);
    }
    if (!section) {
      return res.send(404);
    }
    section.remove(function(err) {
      if (err) {
        return handleError(res, err);
      }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
