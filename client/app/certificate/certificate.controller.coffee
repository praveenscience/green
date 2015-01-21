'use strict'

angular.module 'greenApp'
.controller 'CertificateCtrl', ($scope, Auth, Utils, certificateData, $modal) ->

  $scope.isAdmin = Auth.isAdmin
  $scope.getFormatedDate = Utils.getFormatedDate
  $scope.certificates = []
  $scope.certificateTemplate =
    name: ''
    min: null
    max: null
    logo: null
    sign: null



  $scope.init = ->
    _loadCertificates()

  _loadCertificates = ->
    certificateData.get()
      .success (data, status) ->
        $scope.certificates = data

  $scope.editCertificate = (certificate) ->
    console.log certificate
    modalInstance = $modal.open
      windowClass: 'modal-full'
      templateUrl: '/app/certificate/create.certificate.html'
      controller: 'CreatecertificateCtrl'
      resolve:
        certificate: -> certificate

    modalInstance.result.then (certificate) ->
      _updateCertificate(certificate)

  _updateCertificate = (certificate) ->
    certificateData.update(certificate)
      .success (data, status) ->
        ctf = _.find $scope.certificates, (v) -> v._id is data._id
        ctf = data

  $scope.openNewCertificate = ->
    mdlInstance = $modal.open
      windowClass: 'modal-full'
      templateUrl: '/app/certificate/create.certificate.html'
      controller: 'CreatecertificateCtrl'
      resolve:
        certificate: -> null

    mdlInstance.result.then (certificate) ->
      certificate.status = "published"
      _insertCertificate(certificate)

  _insertCertificate = (certificate) ->
    certificateData.create(certificate)
      .success (data, status) ->
        $scope.certificates.push(data)

  $scope.removeCertificate = (certificate) ->
    console.log certificate
    certificateData.remove(certificate._id)
      .success (data, status) ->
        $scope.certificates.splice $scope.certificates.indexOf(certificate), 1

  $scope.init()
