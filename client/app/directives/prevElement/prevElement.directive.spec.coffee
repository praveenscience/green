'use strict'

describe 'Directive: prevElement', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/prevElement/prevElement.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<prev-element></prev-element>'
    element = $compile(element) scope
    scope.$apply()
    expect(element.text()).toBe 'this is the prevElement directive'

