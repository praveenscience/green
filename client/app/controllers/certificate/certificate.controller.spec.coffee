'use strict'

describe 'Controller: CertificateCtrl', ->

  # load the controller's module
  beforeEach module 'greenApp'
  CertificateCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CertificateCtrl = $controller 'CertificateCtrl',
      $scope: scope
