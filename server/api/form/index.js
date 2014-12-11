'use strict';

var express = require('express');
var controller = require('./form.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id', controller.destroy);

router.put('/s/:id', controller.updatesection)
router.delete('/s/:id', controller.removesection)

module.exports = router;
