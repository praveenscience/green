'use strict'

describe 'Directive: na', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/directives/na/na.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()
