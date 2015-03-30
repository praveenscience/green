'use strict'

describe 'Controller: ResultsCtrl', ->

  # load the controller's module
  beforeEach module 'greenApp'
  ResultsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ResultsCtrl = $controller 'ResultsCtrl',
      $scope: scope
