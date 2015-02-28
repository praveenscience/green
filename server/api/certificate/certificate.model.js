'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var CertificateSchema = new Schema({
  name: String,
  min: Number,
  max: Number,
  author: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  },
  created: {
    type: Date,
    default: Date.now()
  },
  updated: {
    type: Date,
    default: Date.now()
  },
  logo: {
    type: String,
    default: "http://websiddu.com/logo.svg"
  },
  content: {
    type: String,
    default: ""
  },
  sign: {
    type: String,
    default: "http://websiddu.com/logo.svg"
  },
  designation: {
    type: String,
    default: ""
  },
  status: {
    type: String,
    "default": "published",
    enum: ['published', 'unpublished']
  }
});

module.exports = mongoose.model('Certificate', CertificateSchema);
