'use strict'

describe 'Controller: FormsController', ->

  # load the controller's module
  beforeEach module 'greenApp'
  FormsController = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FormsController = $controller 'FormsController',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
