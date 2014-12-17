'use strict';

var _ = require('lodash');
var Form = require('./form.model');

// Get list of forms
exports.index = function(req, res) {
  Form.find(function (err, forms) {
    if(err) { return handleError(res, err); }
    return res.json(200, forms);
  });
};

// Get a single form
exports.show = function(req, res) {
  Form.findById(req.params.id, function (err, form) {
    if(err) { return handleError(res, err); }
    if(!form) { return res.send(404); }
    return res.json(form);
  });
};

// Creates a new form in the DB.
exports.create = function(req, res) {
  Form.create(req.body, function(err, form) {
    if(err) { return handleError(res, err); }
    return res.json(201, form);
  });
};

// Updates an existing form in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Form.findById(req.params.id, function (err, form) {
    if (err) { return handleError(res, err); }
    if(!form) { return res.send(404); }
    var updated = _.merge(form, req.body);
    updated.save(function (err) {
      console.log(err);
      if (err) { return handleError(res, err); }
      return res.json(200, form);
    });
  });
};

exports.updatesection = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Form.findById(req.params.id, function (err, form) {
    if (err) { return handleError(res, err); }
    if(!form) { return res.send(404); }
    form.sections.push(req.body.sections)
    form.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, form);
    });
  });
};


exports.removesection = function(req, res) {
    if(req.body._id) { delete req.body._id; }
      Form.findById(req.params.id, function (err, form) {
        if (err) { return handleError(res, err); }
        if(!form) { return res.send(404); }

        form.sections.splice(form.sections.indexOf(req.body.sections), 1)
        // var updated = _.merge(form, req.body);
        form.save(function (err) {
          if (err) { return handleError(res, err); }
          return res.json(200, form);
        });
  });
}



// Deletes a form from the DB.
exports.destroy = function(req, res) {
  Form.findById(req.params.id, function (err, form) {
    if(err) { return handleError(res, err); }
    if(!form) { return res.send(404); }
    form.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
