'use strict'

describe 'Controller: FieldsCtrl', ->

  # load the controller's module
  beforeEach module 'greenApp'
  FieldsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FieldsCtrl = $controller 'FieldsCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
