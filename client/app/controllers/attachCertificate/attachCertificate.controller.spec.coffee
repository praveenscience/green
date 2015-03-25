'use strict'

describe 'Controller: AttachcertificateCtrl', ->

  # load the controller's module
  beforeEach module 'greenApp'
  AttachcertificateCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AttachcertificateCtrl = $controller 'AttachcertificateCtrl',
      $scope: scope

