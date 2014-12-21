'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var ChoiceSchema = new Schema({
  label: String,
  points: Number
});

module.exports = mongoose.model('Choice', ChoiceSchema);
