'use strict'

describe 'Directive: common', ->

  # load the directive's module
  beforeEach module 'greenApp'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()
