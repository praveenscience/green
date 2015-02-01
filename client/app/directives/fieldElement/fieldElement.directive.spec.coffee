'use strict'

describe 'Directive: fieldElement', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/directives/fieldElement/fieldElement.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<field-element></field-element>'
    element = $compile(element) scope
    scope.$apply()
    expect(element.text()).toBe 'this is the fieldElement directive'

