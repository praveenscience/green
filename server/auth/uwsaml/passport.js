var passport = require('passport');
var uwshib = require('passport-uwshib');
const loginUrl = '/login';

exports.setup = function (User, config) {

  var domain = process.env.DOMAIN || 'green-certification.uw.edu';

  const loginUrl = '/login';
  const loginCallbackUrl = '/login/callback';

  if (!domain || domain.length == 0)
    throw new Error('You must specify the domain name of this server via the DOMAIN environment variable!');


  var publicCert = fs.readFileSync('/usr/local/ssl/certs/greenuw-certs1.s.uw.edu-ss.cert', 'utf-8');
  var privateKey = fs.readFileSync('/usr/local/ssl/certs/greenuw-certs1.s.uw.edu-ss.key', 'utf-8');


  var strategy = new uwshib.Strategy({
    entityId: domain,
    privateKey: privateKey,
    callbackUrl: loginCallbackUrl,
    domain: domain
  });


  passport.use(strategy, function(profile, done){

    console.log(profile);

    User.findOne({
      'email': profile.email
    }, function(err, user) {
      if (err) {
        return done(err);
      }
      if (!user) {
        user = new User({
          name: profile.displayName,
          username: profile.username,
          role: 'user',
          provider: 'twitter',
          twitter: profile._json
        });
        user.save(function(err) {
          if (err) return done(err);
          return done(err, user);
        });
      } else {
        return done(err, user);
      }
    });
    }



  });

};
