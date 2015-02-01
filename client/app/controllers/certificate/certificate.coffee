'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/certificates',
    templateUrl: 'app/controllers/certificate/certificate.html'
    controller: 'CertificateCtrl'
