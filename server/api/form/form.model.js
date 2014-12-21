'use strict';

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var FormSchema = new Schema({
  name: String,
  description: String,
  sections: [{
    type: Schema.Types.ObjectId,
    ref: 'Section'
  }],
  active: Boolean,
  created: {
    type: Date,
    "default": Date.now
  },
  status: {
    type: String,
    "default": "Unpublished",
    enum: ['Published', 'Unpublished']
  },
  author: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  }

});

module.exports = mongoose.model('Form', FormSchema);
