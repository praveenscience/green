'use strict'

angular.module 'greenApp'
.controller 'LoginCtrl', ($scope, Auth, $location, $window) ->

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
        $location.path '/forms'

      .catch (err) ->
        $scope.errors.other = err.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider

  $scope.init()
