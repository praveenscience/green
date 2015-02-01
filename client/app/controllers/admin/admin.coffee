'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider
  .when '/admin',
    templateUrl: 'app/controllers/admin/admin.html'
    controller: 'AdminCtrl'
