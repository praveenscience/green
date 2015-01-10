'use strict'

describe 'Directive: conditionSettings', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/conditionSettings/conditionSettings.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<condition-settings></condition-settings>'
    element = $compile(element) scope
    scope.$apply()
    expect(element.text()).toBe 'this is the conditionSettings directive'

