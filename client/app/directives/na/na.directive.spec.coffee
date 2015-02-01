'use strict'

describe 'Directive: na', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/directives/na/na.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<na></na>'
    element = $compile(element) scope
    scope.$apply()
    expect(element.text()).toBe 'this is the na directive'

