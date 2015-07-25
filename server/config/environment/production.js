'use strict';

// Production specific configuration
// =================================
module.exports = {
  // Server IP
  ip:       process.env.IP ||
            undefined,

  // Server port
  port:     process.env.PORT ||
            8080,

  env: 'production',

  httpPort: process.env.HTTPPORT || 80,
  httpsPort: process.env.HTTPSPORT || 443,

  publicCert: process.env.PUBLICCERT || '/usr/local/ssl/certs/green-certification.uw.edu.cert',
  privateKey: process.env.PRIVATEKEY ||  '/usr/local/ssl/certs/green-certification.uw.edu.key',


  // MongoDB connection options
  mongo: {
    uri:    process.env.MONGOLAB_URI ||
            process.env.MONGOHQ_URL ||
            process.env.OPENSHIFT_MONGODB_DB_URL+process.env.OPENSHIFT_APP_NAME ||
            'mongodb://localhost/green'
  }
};
