'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SectionSchema = new Schema({
  title: String,
  bonus_points: {
    type: Number,
    "default": 0
  },
  possible_points: {
    type: Number,
    "default": 0
  },
  created: {
    type: Date,
    "default": Date.now
  },
  updated: {
    type: Date,
    "default": Date.now
  },
  fields: [{ type: Schema.Types.ObjectId, ref: 'Field' }]
});

module.exports = mongoose.model('Section', SectionSchema);
