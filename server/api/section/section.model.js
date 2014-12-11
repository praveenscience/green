'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SectionSchema = new Schema({
  name: String,
  info: String,
  active: Boolean,
  fields: [{ type: Schema.Types.ObjectId, ref: 'Field' }]
});

module.exports = mongoose.model('Section', SectionSchema);
