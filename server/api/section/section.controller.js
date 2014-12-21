'use strict';

var _ = require('lodash');
var Section = require('./section.model');
var Field = require('../field/field.model');
var Choice = require('../choice/choice.model');
var async = require('async');
var mongoose = require('mongoose');

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

    var newSection = req.body.data;
    var newFields = newSection.fields;
    var fieldsLength = newFields.length;
    var newField = null;
    var newOptions = null;
    var fieldsArray = []
    var newOptionsArray = []
    var preparedFields = []
    var createdNewField = {}

    async.series([
      function(cb) {

        async.each(newFields, function(newField, cb1) {

          if (newField.choices != undefined && newField.choices.length != 0) {

            async.each(newField.choices, function(newOption, cb) {
              var option = new Choice(newOption);
              option.save(function(err, optionN) {
                if (!err) {
                  newOptionsArray.push(optionN._id)
                }
              })

            }, function(err) {

            });
          }

          newField.choices = []

          var fieldId = newField._id || mongoose.Types.ObjectId();
          delete newField._id

          Field.update({
              _id: fieldId
            }, newField, {
              upsert: true
            })
            .exec(function(err, fieldN) {
              fieldsArray.push(fieldId);
              if (newField.sequence == (fieldsLength - 1)) {
                cb(null)
              }
            });

          // var createdField = new Field(newField);

          // createdField.save(function(err, fieldN){
          //   console.log(err)
          //   fieldsArray.push(fieldN.id);
          //   cb(null);
          // });

        }, function(err) {})
      },
      function(cb) {
        section.fields = fieldsArray
        section.save(function(err) {
          if (err) {
            return handleError(res, err);
          }
          return res.json(200, section);
        });
        cb(null);
      }
    ])
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
