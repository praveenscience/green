'use strict'

describe 'Controller: FormshowCtrl', ->

  # load the controller's module
  beforeEach module 'greenApp'
  FormshowCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FormshowCtrl = $controller 'FormshowCtrl',
      $scope: scope
