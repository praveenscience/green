'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var ChoiceSchema = new Schema({
  label: String,
  points: Number,
  help_text: String,
  has_helptext: {
    type: Boolean,
    default: false
  },
  help_text_html: {
    type: String,
    default: ''
  },
  seq: {
    type: Number,
    default: 0
  },
  is_na: {
    type: Boolean,
    default: false
  },
  is_condition: {
    type: Boolean,
    default: false
  },
  show_field: {
    type: Array,
    default: ''
  }
});

module.exports = mongoose.model('Choice', ChoiceSchema);
