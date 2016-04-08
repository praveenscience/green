'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/forms/:id/:res/success',
    authenticate: true
    templateUrl: 'app/controllers/formshow/success.html'
    controller: 'FormshowSuccessCtrl'

  $routeProvider.when '/forms/:id/:res',
    authenticate: true
    templateUrl: 'app/controllers/formshow/formshow.html'
    controller: 'FormshowCtrl'
  $routeProvider.when '/forms/:id',
    authenticate: true
    templateUrl: 'app/controllers/formshow/formshow.html'
    controller: 'FormshowCtrl'
