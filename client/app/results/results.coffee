'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/results/:id',
    templateUrl: 'app/results/results.html'
    controller: 'ResultsCtrl'
