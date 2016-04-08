'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/results/:id',
    authenticate: true
    templateUrl: 'app/controllers/results/results.html'
    controller: 'ResultsCtrl'
  $routeProvider.when '/results/:id/:res',
    authenticate: true
    templateUrl: 'app/controllers/results/responses.html'
    controller: 'ResponseCtrl'

