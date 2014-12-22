'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/forms',
    templateUrl: 'app/forms/forms.html'
    controller: 'FormsController'
    authenticate: true

