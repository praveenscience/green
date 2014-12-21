'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SectionSchema = new Schema({
  title: String,
  fields: [{ type: Schema.Types.ObjectId, ref: 'Field' }]
});

module.exports = mongoose.model('Section', SectionSchema);
