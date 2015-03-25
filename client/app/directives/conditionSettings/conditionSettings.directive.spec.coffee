'use strict'

describe 'Directive: conditionSettings', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/directives/conditionSettings/conditionSettings.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()
