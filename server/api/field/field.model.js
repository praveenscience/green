'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var FieldSchema = new Schema({
  name: String,
  info: String,
  active: Boolean,
  "answers": [{ type: Schema.Types.ObjectId, ref: 'Option' }]
});

module.exports = mongoose.model('Field', FieldSchema);
