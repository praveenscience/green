'use strict';

var _ = require('lodash');

// Get list of fields
exports.index = function(req, res) {
  res.download(__dirname + '/../exported-files/' + req.params.id, req.params.id.slice(0, -4) + '–report.csv');
};

function handleError(res, err) {
  return res.send(500, err);
}
