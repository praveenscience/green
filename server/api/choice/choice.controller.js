'use strict';

var _ = require('lodash');
var Choice = require('./choice.model');

// Get list of choices
exports.index = function(req, res) {
  Choice.find(function (err, choices) {
    if(err) { return handleError(res, err); }
    return res.json(200, choices);
  });
};

// Get a single choice
exports.show = function(req, res) {
  Choice.findById(req.params.id, function (err, choice) {
    if(err) { return handleError(res, err); }
    if(!choice) { return res.send(404); }
    return res.json(choice);
  });
};

// Creates a new choice in the DB.
exports.create = function(req, res) {
  Choice.create(req.body, function(err, choice) {
    if(err) { return handleError(res, err); }
    return res.json(201, choice);
  });
};

// Updates an existing choice in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Choice.findById(req.params.id, function (err, choice) {
    if (err) { return handleError(res, err); }
    if(!choice) { return res.send(404); }
    var updated = _.merge(choice, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, choice);
    });
  });
};

// Deletes a choice from the DB.
exports.destroy = function(req, res) {
  Choice.findById(req.params.id, function (err, choice) {
    if(err) { return handleError(res, err); }
    if(!choice) { return res.send(404); }
    choice.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
