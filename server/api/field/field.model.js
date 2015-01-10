'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var FieldSchema = new Schema({
  label: String,
  help_text: String,
  type: String,
  required: String,
  sequence: Number,
  edit_mode: Boolean,
  condition: {
    field: { type: Schema.Types.ObjectId, ref: 'Field' },
    choice: { type: Schema.Types.ObjectId, ref: 'Choice' }
  },
  has_condition: {
    type: Boolean,
    default: false
  },
  is_bonus: {
    type: Boolean,
    default: false
  },
  choices: [{ type: Schema.Types.ObjectId, ref: 'Choice' }],
  field_validation: {
    is_required: String,
    type: String,
    category: String,
    data: String,
    message: String
  }
});

module.exports = mongoose.model('Field', FieldSchema);
