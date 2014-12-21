/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var choice = require('./choice.model');

exports.register = function(socket) {
  choice.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  choice.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('choice:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('choice:remove', doc);
}
