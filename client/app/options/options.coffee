'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/options',
    templateUrl: 'app/options/options.html'
    controller: 'OptionsCtrl'
