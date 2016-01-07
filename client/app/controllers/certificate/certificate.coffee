'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/certificates',
    templateUrl: 'app/controllers/certificate/certificate.html'
    controller: 'CertificateCtrl'
    resolve:
      certificate: ($route) ->
        return null

  .when '/certificates/new',
    templateUrl: 'app/controllers/certificate/create_certificate.html'
    controller: 'CertificateCtrl'
    resolve:
      certificate: ($route) ->
        return null

  .when '/certificates/:id',
    templateUrl: 'app/controllers/certificate/create_certificate.html'
    controller: 'CertificateCtrl'
    resolve:
      certificate: ($q, $timeout, $route, $http) ->
        deferred = $q.defer()
        $http
          url: "/api/certificates/#{$route.current.params.id}"
          method: 'GET'
        .success (data, status) ->
          deferred.resolve data
        deferred.promise
