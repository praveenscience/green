/**
 * Main application file
 */

'use strict';

// Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

var express = require('express');
var mongoose = require('mongoose');
var config = require('./config/environment');
var http = require('http');
var https = require('https');
var fs = require('fs');

// Connect to database
mongoose.connect(config.mongo.uri, config.mongo.options);

// Populate DB with sample data
if (config.seedDB) {
  require('./config/seed');
}

// Setup server
var app = express();
//var server = require('http').createServer(app);

app.disable('x-powered-by');
var socketio = require('socket.io')(server, {
  serveClient: (config.env === 'production') ? false : true,
  path: '/socket.io-client'
});
require('./config/socketio')(socketio);
require('./config/express')(app);
require('./routes')(app);


var server;

if (config.env === 'production') {
  var options = {
    key: fs.readFileSync(config.privateKey, 'utf-8'),
    cert: fs.readFileSync(config.publicCert, 'utf-8')
  };
  server = require('https').createServer(options, app);

  var httpServer = http.createServer(function(req, res) {
    var redirUrl = 'https://' + domain;
    if (config.httpsPort != 443)
      redirUrl += ':' + config.httpsPort;
    redirUrl += req.url;

    res.writeHead(301, {
      'Location': redirUrl
    });
    res.end();
  });

  server.listen(httpsPort, function() {
    console.log('Listening for HTTPS requests on port %d', config.httpsPort)
  });

} else {
  server = require('http').createServer(app);
  // Start server
  server.listen(config.port, config.ip, function() {
    console.log('Express server listening on %d, in %s mode', config.port, app.get('env'));
  });
}

// Expose app
exports = module.exports = app;
