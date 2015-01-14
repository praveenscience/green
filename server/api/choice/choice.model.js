'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var ChoiceSchema = new Schema({
  label: String,
  points: Number,
  is_na: {
    type: Boolean,
    default: false
  },
  is_condition: {
    type: Boolean,
    default: false
  },
  show_field: {
    type: String,
    default: ''
  }
});

module.exports = mongoose.model('Choice', ChoiceSchema);
