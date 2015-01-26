'use strict'

angular.module 'greenApp'
.controller 'AttachcertificateCtrl', ($scope, $modalInstance, certificateData) ->

  # $scope.certificate = certificate || {}
  $scope.init = ->
    _loadCertificates()

  _loadCertificates = ->
    certificateData.get()
      .success (data, status) ->
        $scope.certificates = data


  $scope.ok = ->
    $modalInstance.close();

  $scope.cancel = ->
    $modalInstance.dismiss('cancel');

  $scope.init()


