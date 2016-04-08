'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider
  .when '/admin',
    authenticate: true
    templateUrl: 'app/controllers/admin/admin.html'
    controller: 'AdminCtrl'
