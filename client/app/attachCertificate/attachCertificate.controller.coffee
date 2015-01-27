'use strict'

angular.module 'greenApp'
.controller 'AttachcertificateCtrl', ($scope, $modalInstance, certificateData, selectedCertificates) ->

  # $scope.certificate = certificate || {}

  $scope.init = ->
    _loadCertificates()

  _loadCertificates = ->
    certificateData.get()
      .success (data, status) ->
        $scope.certificates = data

  $scope.ok = ->
    selected_cert = _.find $scope.certificates, (v) -> v.selected is true
    $modalInstance.close(selected_cert);

  $scope.cancel = ->
    $modalInstance.dismiss('cancel');

  $scope.init()


