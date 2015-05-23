'use strict';

var express = require('express');
var passport = require('passport');
var auth = require('../auth.service');
var uwshib = require('passport-uwshib');
var fs = require('fs');

var router = express.Router();

// var strategy = new uwshib.Strategy({
//     entityId: domain,
//     privateKey: privateKey,
//     callbackUrl: loginCallbackUrl,
//     domain: domain
// });

// var domain = process.env.DOMAIN || 'green-certification.uw.edu';

// var loginUrl = '/login';
// var loginCallbackUrl = '/login/callback';

// if (!domain || domain.length == 0)
//   throw new Error('You must specify the domain name of this server via the DOMAIN environment variable!');


// var publicCert = fs.readFileSync('/usr/local/ssl/certs/greenuw-certs1.s.uw.edu-ss.cert', 'utf-8');
// var privateKey = fs.readFileSync('/usr/local/ssl/certs/greenuw-certs1.s.uw.edu-ss.key', 'utf-8');



// passport.use(strategy);

// passport.serializeUser(function(user, done){
//     done(null, user);
// });

// passport.deserializeUser(function(user, done){
//     done(null, user);
// });

// router.get(loginUrl, passport.authenticate(strategy.name), uwshib.backToUrl());
// router.post(loginCallbackUrl, passport.authenticate(strategy.name), uwshib.backToUrl());
// router.get(uwshib.urls.metadata, uwshib.metadataRoute(strategy, publicCert));

router
  .get('/', passport.authenticate('uwsaml', {
    failureRedirect: uwshib.backToUrl(),
    session: false
  }),
    function(req, res) {
      res.redirect('/forms');
    }
  )
  //.get(uwshib.urls.metadata, uwshib.metadataRoute(strategy, publicCert));
  .get('/callback', passport.authenticate('uwsaml', {
    failureRedirect: uwshib.backToUrl(),
    session: false
  }), auth.setTokenCookie);

module.exports = router;
