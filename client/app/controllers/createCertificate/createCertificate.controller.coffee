'use strict'

angular.module 'greenApp'
.controller 'CreatecertificateCtrl', ($scope, $modalInstance, certificate) ->

  $scope.certificate = certificate || {}

  $scope.formattedDate = ->
    date = new Date()
    return date.toUTCString().substr(5, 11)

  $scope.ok = ->
    $modalInstance.close($scope.certificate);

  $scope.cancel = ->
    $modalInstance.dismiss('cancel');
