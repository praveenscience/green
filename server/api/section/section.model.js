'use strict';

var mongoose = require('mongoose'),
  async = require('async'),
  Field = require('../field/field.model'),
  Schema = mongoose.Schema;

var SectionSchema = new Schema({
  title: String,
  bonus_points: {
    type: Number,
    "default": 0
  },
  possible_points: {
    type: Number,
    "default": 0
  },
  created: {
    type: Date,
    "default": Date.now
  },
  updated: {
    type: Date,
    "default": Date.now
  },
  fields: [{
    type: Schema.Types.ObjectId,
    ref: 'Field'
  }]
});


SectionSchema
  .pre('remove', function(next) {
    var fields = this.fields;

    if (fields && fields.length > 0) {
      async.each(fields, function(fldId, callback) {
        Field.findByIdAndRemove(fldId, function(flderr, fld) {
          if (fld && !flderr) {
            fld.remove(function(err) {
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

module.exports = mongoose.model('Section', SectionSchema);
