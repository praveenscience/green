'use strict';

var _ = require('lodash');
var Certificate = require('./certificate.model');

// Get list of certificates
exports.index = function(req, res) {
  Certificate.find(function (err, certificates) {
    if(err) { return handleError(res, err); }
    return res.status(200).json(certificates);
  });
};

// Get a single certificate
exports.show = function(req, res) {
  Certificate.findById(req.params.id, function (err, certificate) {
    if(err) { return handleError(res, err); }
    if(!certificate) { return res.send(404); }
    return res.status(200).json(certificate);
  });
};

// Creates a new certificate in the DB.
exports.create = function(req, res) {
  var certificate = req.body;
  certificate.author = req.user._id;
  Certificate.create(certificate, function(err, certificate) {
    if(err) { return handleError(res, err); }
    return res.status(201).json(certificate);
  });
};

// Updates an existing certificate in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Certificate.findById(req.params.id, function (err, certificate) {
    if (err) { return handleError(res, err); }
    if(!certificate) { return res.send(404); }
    var updated = _.merge(certificate, req.body);
    updated.updated = Date.now();
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.status(200).json(certificate);
    });
  });
};

// Deletes a certificate from the DB.
exports.destroy = function(req, res) {
  Certificate.findById(req.params.id, function (err, certificate) {
    if(err) { return handleError(res, err); }
    if(!certificate) { return res.send(404); }
    certificate.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
