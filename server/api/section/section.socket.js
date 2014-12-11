/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Section = require('./section.model');

exports.register = function(socket) {
  Section.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Section.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('section:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('section:remove', doc);
}