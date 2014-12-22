'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/forms/:id',
    templateUrl: 'app/formshow/formshow.html'
    controller: 'FormshowCtrl'
