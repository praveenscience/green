'use strict'

angular.module 'greenApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'ngAnimate'
  'btford.socket-io'
  'ui.bootstrap'
  'ui.sortable'
  'angular-ladda'
  'oitozero.ngSweetAlert'
  'ui.select'
  'ngQuill'
  'monospaced.elastic'
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
    if response.status == 401
      # Create cookie with location info before redirecting
      hostArray = location.host.split('.');
      if hostArray[hostArray.length - 1] is 'edu'
        if $location.url() isnt '/login'
          $cookieStore.put 'returnUrl', $location.url()
        $location.path '/'
      else
        if $location.url() != '/lg'
          $cookieStore.put 'returnUrl', $location.url()
        $location.path '/lg'

      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, $location, Auth, $cookieStore) ->
  # editableOptions.theme = 'bs3'
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$routeChangeStart', (event, next) ->
    Auth.isLoggedInAsync (loggedIn) ->
      hostArray = location.host.split('.');
      if hostArray[hostArray.length - 1] is 'edu'
        if $location.url() isnt '/login' and !$cookieStore.get('returnUrl')
          $cookieStore.put('returnUrl', $location.url());
        if next.authenticate and !loggedIn
          window.location.href = "/login"
      else
        if $location.url() isnt '/lg'
          $cookieStore.put('returnUrl', $location.url());
        if next.authenticate and !loggedIn
          window.location.href = "/lg"
