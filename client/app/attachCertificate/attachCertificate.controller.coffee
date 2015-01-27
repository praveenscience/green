'use strict'

angular.module 'greenApp'
.controller 'AttachcertificateCtrl', ($scope, $modalInstance, certificateData, selectedCertificates) ->

  $scope.certificates = []

  $scope.init = ->
    _loadCertificates()

  _loadCertificates = ->
    certificateData.get()
      .success (data, status) ->
        $scope.certificates = data

  $scope.ok = ->
    selected_cert = []
    $scope.certificates.forEach (cert) ->
      if cert.selected is true
        selected_cert.push(cert)

    $modalInstance.close(selected_cert);

  $scope.cancel = ->
    $modalInstance.dismiss('cancel');

  $scope.init()


