'use strict'

angular.module 'greenApp'
.controller 'CertificateCtrl', ($scope, Auth, Utils, certificateData, $modal, certificate, $location) ->

  $scope.isAdmin = Auth.isAdmin
  $scope.getFormatedDate = Utils.getFormatedDate
  $scope.certificates = []
  $scope.enableSaveButton = false
  $scope.certificateSaving = false
  $scope.certificateTemplate =
    name: ''
    min: null
    max: null
    logo: null
    sign: null

  $scope.certificate = null

  $scope.init = ->
    setTimeout ->
      $scope.enableSaveButton = true
      $scope.$apply()
    , 10
    if certificate
      $scope.certificate = certificate
      $scope.updated = certificate.updated
    else
      _loadCertificates()

  _loadCertificates = ->
    certificateData.get()
      .success (data, status) ->
        $scope.certificates = data


  _updateCertificate = (certificate) ->
    $scope.certificateSaving = true
    certificateData.update(certificate)
      .success (data, status) ->
        $scope.certificateSaving = false
        $scope.enableSaveButton = true

  $scope.updateCertificate = ->
    if $scope.certificate._id != undefined
      _updateCertificate($scope.certificate)
    else
      $scope.certificate.status = "published"
      _insertCertificate($scope.certificate)


  $scope.formattedDate = ->
    date = new Date()
    return date.toUTCString().substr(5, 11)


  _insertCertificate = (certificate) ->
    certificateData.create(certificate)
      .success (data, status) ->
        $location.path "certificates/#{data._id}"

  $scope.removeCertificate = (certificate) ->
    certificateData.remove(certificate._id)
      .success (data, status) ->
        $scope.certificates.splice $scope.certificates.indexOf(certificate), 1


  $scope.$watch('certificate', (old, newValue) ->
    $scope.enableSaveButton = false
  , true)

  $scope.init()
