'use strict'

describe 'Directive: fieldElement', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/directives/fieldElement/fieldElement.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()
