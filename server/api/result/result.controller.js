'use strict';

var _ = require('lodash');
var Result = require('./result.model');
var User = require('../user/user.model');

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
  }).exec(function(err, result) {
    if(err) { return handleError(res, err); }
    if(!result) { return res.send(404); }
    return res.json(result);
  })

};

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
  var formId = req.body.form;
  var userId = req.user.id;

  var resultId = req.body.results_id;

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
    results: req.body.results
  }

  if(resultId == undefined) {
    Result.create(result, function(err, createdItem) {
      if(err) { return handleError(res, err); }
      return res.json(201, createdItem);
    });
  }

  else {
    Result.update({
      _id: resultId
    }, result).exec(function(err, resl){
      if (err) { return handleError(resl, err); }
      result._id = resultId;
      return res.send(200, result);
    });
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
