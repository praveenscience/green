'use strict';

var express = require('express');
var controller = require('./result.controller');
var auth = require('../../auth/auth.service');

var router = express.Router();

router.get('/', auth.isAuthenticated(), controller.index);
router.get('/submissions', auth.isAuthenticated(), controller.submissions);
router.get('/:id', auth.isAuthenticated(), controller.show);
router.get('/:id/all', auth.isAuthenticated(), controller.showallresults);
router.get('/:id/export', auth.isAuthenticated(), controller.getCSV);
router.post('/', auth.isAuthenticated(), controller.create);
router.put('/:id', auth.isAuthenticated(), controller.update);
router.patch('/:id', auth.isAuthenticated(), controller.update);
router.delete('/:id', auth.isAuthenticated(), controller.destroy);

module.exports = router;
