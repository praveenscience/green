'use strict'

describe 'Directive: typeBadge', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/directives/typeBadge/typeBadge.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()
