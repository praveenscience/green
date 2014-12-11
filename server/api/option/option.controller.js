'use strict';

var _ = require('lodash');
var Option = require('./option.model');

// Get list of options
exports.index = function(req, res) {
  Option.find(function (err, options) {
    if(err) { return handleError(res, err); }
    return res.json(200, options);
  });
};

// Get a single option
exports.show = function(req, res) {
  Option.findById(req.params.id, function (err, option) {
    if(err) { return handleError(res, err); }
    if(!option) { return res.send(404); }
    return res.json(option);
  });
};

// Creates a new option in the DB.
exports.create = function(req, res) {
  Option.create(req.body, function(err, option) {
    if(err) { return handleError(res, err); }
    return res.json(201, option);
  });
};

// Updates an existing option in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Option.findById(req.params.id, function (err, option) {
    if (err) { return handleError(res, err); }
    if(!option) { return res.send(404); }
    var updated = _.merge(option, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, option);
    });
  });
};

// Deletes a option from the DB.
exports.destroy = function(req, res) {
  Option.findById(req.params.id, function (err, option) {
    if(err) { return handleError(res, err); }
    if(!option) { return res.send(404); }
    option.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}