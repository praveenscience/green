'use strict'

describe 'Controller: CreatecertificateCtrl', ->

  # load the controller's module
  beforeEach module 'greenApp'
  CreatecertificateCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CreatecertificateCtrl = $controller 'CreatecertificateCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
