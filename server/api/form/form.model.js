'use strict';

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var FormSchema = new Schema({
  name: String,
  description: String,
  logo: {
    type: String,
    "default": 'assets/images/green_labs.png'
  },
  updated: {
    type: Date,
    "default": Date.now
  },
  sections: [{
    type: Schema.Types.ObjectId,
    ref: 'Section'
  }],
  active: Boolean,
  created: {
    type: Date,
    "default": Date.now
  },
  total_points: {
    type: Number,
    default: 0
  },
  status: {
    type: String,
    "default": "Unpublished",
    enum: ['Published', 'Unpublished']
  },
  author: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  },
  certificates: [{
    type: Schema.Types.ObjectId,
    ref: 'Certificate'
  }]
});

module.exports = mongoose.model('Form', FormSchema);
