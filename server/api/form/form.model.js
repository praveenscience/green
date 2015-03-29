'use strict';

var mongoose = require('mongoose'),
  async = require('async'),
  Section = require('../section/section.model'),
  Schema = mongoose.Schema;

var FormSchema = new Schema({
  name: String,
  description: String,
  logo: {
    type: String,
    "default": 'assets/images/green_labs.png'
  },
  updated: {
    type: Date,
    "default": Date.now
  },
  sections: [{
    type: Schema.Types.ObjectId,
    ref: 'Section'
  }],
  active: Boolean,
  created: {
    type: Date,
    "default": Date.now
  },
  total_points: {
    type: Number,
    default: 0
  },
  expires_in: {
    number: {
      type: Number,
      default: null
    },
    unit: {
      type: String,
      enum: ['years', 'months', 'weeks', 'days', 'hours', 'minutes', 'seconds']
    }
  },
  no_certificate: {
    type: String,
    default: ''
  },
  status: {
    type: String,
    "default": "Unpublished",
    enum: ['Published', 'Unpublished']
  },
  author: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  },
  certificates: [{
    type: Schema.Types.ObjectId,
    ref: 'Certificate'
  }]
});

FormSchema
  .pre('remove', function(next) {
    var sections = this.sections;

    if (sections && sections.length > 0) {

      async.each(sections, function(sec, callback) {
        Section.findByIdAndRemove(sec, function(secerr, secobj) {
          if (!secerr && secobj) {
            secobj.remove(function(err) {
              if (!err) callback();
            });
          }
        })
      }, function(err) {
        if (!err) {
          next();
        }
      });

    } else {
      next()
    }

  });

module.exports = mongoose.model('Form', FormSchema);
