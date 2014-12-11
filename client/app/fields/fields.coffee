'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/fields',
    templateUrl: 'app/fields/fields.html'
    controller: 'FieldsCtrl'
