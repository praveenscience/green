'use strict'

angular.module 'greenApp'
.controller 'LoginCtrl', ($scope, Auth, $location, $window, $cookieStore) ->

  rand = Math.floor((Math.random()*4)+1)

  $scope.loginBgStyle =
    "background-image": "url(assets/images/login-#{rand}.jpeg)"

  $scope.user = {}
  $scope.errors = {}

  $scope.init = ->
    hostArray = location.host.split('.');
    # if Auth.isLoggedIn()
    #   $location.path '/forms'
    # if hostArray[hostArray.length - 1] is 'edu'
    #   $location.path '/login'

  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.login
        email: $scope.user.email
        password: $scope.user.password

      .then ->
        if typeof $cookieStore.get('returnUrl') != 'undefined' and $cookieStore.get('returnUrl') != ''
          $location.path $cookieStore.get('returnUrl')
          $cookieStore.remove 'returnUrl'
        else
          $location.path '/'

      .catch (err) ->
        $scope.errors.other = err.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/login/' + provider

  $scope.init()
