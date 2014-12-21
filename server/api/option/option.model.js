'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var OptionSchema = new Schema({
  label: String,
  points: Number
});

module.exports = mongoose.model('Option', OptionSchema);
