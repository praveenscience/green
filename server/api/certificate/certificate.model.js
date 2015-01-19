'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var CertificateSchema = new Schema({
  name: String,
  min: Number,
  max: Number,
  logo: {
    type: String,
    default: "http://websiddu.com/logo.svg"
  },
  sign: {
    type: String,
    default: "http://websiddu.com/logo.svg"
  },
  status: {
    type: String,
    "default": "published",
    enum: ['published', 'unpublished']
  }
});

module.exports = mongoose.model('Certificate', CertificateSchema);
