'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var OptionSchema = new Schema({
  name: String,
  value: Number,
  active: Boolean
});

module.exports = mongoose.model('Option', OptionSchema);
