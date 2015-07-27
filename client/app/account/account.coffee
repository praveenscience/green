'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider
  .when '/',
    templateUrl: (urlatt) ->
      return 'app/controllers/forms/forms.html'
    controller: 'FormsController'
    authenticate: true

  # .when '/login',
  #   templateUrl: 'app/account/login/login.html'
  #   controller: 'LoginCtrl'

  .when '/signup',
    templateUrl: 'app/account/signup/signup.html'
    controller: 'SignupCtrl'

  .when '/settings',
    templateUrl: 'app/account/settings/settings.html'
    controller: 'SettingsCtrl'
    authenticate: true
