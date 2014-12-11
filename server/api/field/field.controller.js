'use strict';

var _ = require('lodash');
var Field = require('./field.model');

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
  Field.create(req.body, function(err, field) {
    if(err) { return handleError(res, err); }
    return res.json(201, field);
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