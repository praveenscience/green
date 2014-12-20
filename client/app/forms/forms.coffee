'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/forms',
    templateUrl: 'app/forms/forms.html'
    controller: 'FormsController'
    authenticate: true
  $routeProvider.when '/forms/edit/:id',
    templateUrl: 'app/create/create.html'
    controller: 'CreateController'
    authenticate: true
