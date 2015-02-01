'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/forms/edit/:id',
    templateUrl: 'app/controllers/create/create.html'
    controller: 'CreateController'
    authenticate: true
