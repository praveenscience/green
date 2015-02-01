'use strict'

describe 'Directive: common', ->

  # load the directive's module
  beforeEach module 'greenApp'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<common></common>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the common directive'
