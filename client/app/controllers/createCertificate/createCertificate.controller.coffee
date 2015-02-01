'use strict'

angular.module 'greenApp'
.controller 'CreatecertificateCtrl', ($scope, $modalInstance, certificate) ->
  $scope.certificate = certificate || {}

  $scope.ok = ->
    $modalInstance.close($scope.certificate);

  $scope.cancel = ->
    $modalInstance.dismiss('cancel');
