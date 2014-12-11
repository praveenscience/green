/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Option = require('./option.model');

exports.register = function(socket) {
  Option.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Option.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('option:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('option:remove', doc);
}