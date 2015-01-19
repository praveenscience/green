'use strict';

var _ = require('lodash');
var Result = require('./result.model');

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
    form_id: req.params.id,
    user_id: req.user._id
  }).exec(function(err, result) {
    if(err) { return handleError(res, err); }
    if(!result) { return res.send(404); }
    return res.json(result);
  })

};

exports.showallresults = function(req, res) {
  Result.find({
    form_id: req.params.id
  }).exec(function(err, result) {
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
  var formId = req.body.form_id;
  var userId = req.user.id;

  console.log(req.user.id);

  var result = {
    user_id: userId,
    form_id: formId,
    updated: Date.now(),
    submitted: req.body.submitted,
    results: req.body.results
  }

  Result.update({
    form_id: formId,
    user_id: userId
  }, result, { upsert: true}).exec(function(err, resl){
    if (err) { return handleError(resl, err); }
    return res.send(200, result);
  });

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
