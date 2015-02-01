'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/results/:id',
    templateUrl: 'app/controllers/results/results.html'
    controller: 'ResultsCtrl'
