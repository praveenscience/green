'use strict'

angular.module 'greenApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ngAnimate',
  'btford.socket-io',
  'ui.bootstrap',
  'ui.sortable',
  'angular-ladda'
  'ngSweetAlert'
]

.config ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider
  .otherwise
    redirectTo: '/forms'

  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get 'token' if $cookieStore.get 'token'
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $location.path '/'
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, $location, Auth) ->
  # editableOptions.theme = 'bs3'
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$routeChangeStart', (event, next) ->
    Auth.isLoggedInAsync (loggedIn) ->
      $location.path "/login" if next.authenticate and not loggedIn



