'use strict';

var _ = require('lodash');
var Form = require('./form.model');
var Section = require('../section/section.model');
var Field = require('../field/field.model');
var Choice = require('../choice/choice.model');
var Certificate = require('../certificate/certificate.model');
var auth = require('../../auth/auth.service');

// Get list of forms
exports.index = function(req, res) {

  var condition = {}
  if(req.user.role != "admin") {
    condition.status = 'Published'
  }

  Form.find(condition)
    .populate('author')
    .exec(function(err, forms) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, forms);
    });

};

// Get a single form
exports.show = function(req, res) {
  Form.findById(req.params.id)
    .lean()
    .populate('sections')
    .exec(function(err, form) {
      if (err) {
        return handleError(res, err);
      }
      if (!form) {
        return res.send(404);
      }
      Section.populate(form, {
        path: 'sections.fields',
        model: Field
      }, function(err, formFields) {
        Choice.populate(formFields, {
          path: 'sections.fields.choices',
          model: Choice
        }, function(err, formOptions) {
          Certificate.populate(formOptions, {
            path: 'certificates',
            model: Certificate
          }, function(err, certificatesForm) {
            return res.json(certificatesForm);
          })
        })
      })
    });
};

// Creates a new form in the DB.
exports.create = function(req, res) {
  var data = req.body;

  var choice = new Choice(data.sections[0].fields[0].choices[0]);

  choice.save(function(err, optn) {
    if (err) return handleError(err);
    var field = data.sections[0].fields[0];
    field.choices = []
    field.choices.push(optn._id);
    var fieldObj = new Field(field);
    fieldObj.save(function(err, fld) {
      if (err) return handleError(err);
      var section = data.sections[0];
      section.fields = []
      section.fields.push(fld._id);
      var sectionObj = new Section(section);
      sectionObj.save(function(err, sect) {
        if (err) return handleError(err);
        var form = data
        form.sections = []
        form.sections.push(sect._id);
        form.author = req.user._id
        var formObj = new Form(form);
        formObj.save(function(err, frm) {
          if (err) return handleError(err);
          return res.json(201, frm);
        })
      });
    });
  });
};

// Updates an existing form in the DB.
exports.update = function(req, res) {
  if (req.body._id) {
    delete req.body._id;
  }
  Form.findById(req.params.id, function(err, form) {
    if (err) {
      return handleError(res, err);
    }
    if (!form) {
      return res.send(404);
    }
    req.body.sections = undefined;
    form.certificates = undefined;
    req.body.__v = undefined;
    var updated = _.merge(form, req.body);
    updated.save(function(err) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, form);
    });
  });
};

exports.updatesection = function(req, res) {
  if (req.body._id) {
    delete req.body._id;
  }
  Form.findById(req.params.id, function(err, form) {
    if (err) {
      return handleError(res, err);
    }
    if (!form) {
      return res.send(404);
    }
    form.sections.push(req.body.sections)
    form.save(function(err) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, form);
    });
  });
};

exports.removesection = function(req, res) {
  if (req.body._id) {
    delete req.body._id;
  }
  Form.findById(req.params.id, function(err, form) {
    if (err) {
      return handleError(res, err);
    }
    if (!form) {
      return res.send(404);
    }

    form.sections.splice(form.sections.indexOf(req.body.sections), 1)
      // var updated = _.merge(form, req.body);
    form.save(function(err) {
      if (err) {
        return handleError(res, err);
      }
      return res.json(200, form);
    });
  });
}

// Deletes a form from the DB.
exports.destroy = function(req, res) {
  Form.findById(req.params.id, function(err, form) {
    if (err) {
      return handleError(res, err);
    }
    if (!form) {
      return res.send(404);
    }
    form.remove(function(err) {
      if (err) {
        return handleError(res, err);
      }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
