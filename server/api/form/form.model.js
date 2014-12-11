'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var FormSchema = new Schema({
  name: String,
  info: String,
  sections : [{ type: Schema.Types.ObjectId, ref: 'Section' }],
  active: Boolean
});

module.exports = mongoose.model('Form', FormSchema);
