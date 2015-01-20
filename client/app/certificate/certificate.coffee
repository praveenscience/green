'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/certificates',
    templateUrl: 'app/certificate/certificate.html'
    controller: 'CertificateCtrl'
