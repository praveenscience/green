'use strict';

var _ = require('lodash');
var Field = require('./field.model');
var Choice = require('../choice/choice.model');

// Get list of fields
exports.index = function(req, res) {
  Field.find(function (err, fields) {
    if(err) { return handleError(res, err); }
    return res.json(200, fields);
  });
};

// Get a single field
exports.show = function(req, res) {
  Field.findById(req.params.id, function (err, field) {
    if(err) { return handleError(res, err); }
    if(!field) { return res.send(404); }
    return res.json(field);
  });
};

// Creates a new field in the DB.
exports.create = function(req, res) {

  var data = req.body;
  var choice = new Choice(data.choices[0]);

  choice.save(function(err, optn) {
    if (err) return handleError(err);
    var field = data;
    field.choices = []
    field.choices.push(optn._id);
    var fieldObj = new Field(field);
    fieldObj.save(function(err, fld) {
      if(err) { return handleError(res, err); }
      console.log(fld);
      return res.json(201, fld);
    });

  });
};

// Updates an existing field in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Field.findById(req.params.id, function (err, field) {
    if (err) { return handleError(res, err); }
    if(!field) { return res.send(404); }
    var updated = _.merge(field, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, field);
    });
  });
};

// Deletes a field from the DB.
exports.destroy = function(req, res) {
  Field.findById(req.params.id, function (err, field) {
    if(err) { return handleError(res, err); }
    if(!field) { return res.send(404); }
    field.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
