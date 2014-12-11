'use strict'

describe 'Controller: OptionsCtrl', ->

  # load the controller's module
  beforeEach module 'greenApp'
  OptionsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    OptionsCtrl = $controller 'OptionsCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
