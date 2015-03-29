'use strict';

var mongoose = require('mongoose'),
  async = require('async'),
  Choice = require('../choice/choice.model'),
  Schema = mongoose.Schema;

var FieldSchema = new Schema({
  label: String,
  help_text: String,
  type: String,
  required: String,
  sequence: Number,
  edit_mode: Boolean,
  possible_points: {
    type: Number,
    default: 0
  },
  condition: {
    field: {
      type: String,
      default: ''
    },
    choice: [{
      type: String,
      default: ''
    }]
  },
  has_condition: {
    type: Boolean,
    default: false
  },
  has_na: {
    type: Boolean,
    default: false
  },
  is_bonus: {
    type: Boolean,
    default: false
  },
  choices: [{
    type: Schema.Types.ObjectId,
    ref: 'Choice'
  }],
  field_validation: {
    is_required: String,
    type: String,
    category: String,
    data: String,
    message: String
  }
});

FieldSchema
  .pre('remove', function(next) {
    var choices = this.choices;
    if (choices && choices.length > 0) {

      async.each(choices, function(choId, callback) {
        Choice.findByIdAndRemove(choId, function(choerr, cho) {
          if (cho && !choerr) {
            cho.remove(function(err) {
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


module.exports = mongoose.model('Field', FieldSchema);
