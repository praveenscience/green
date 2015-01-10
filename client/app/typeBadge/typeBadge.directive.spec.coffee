'use strict'

describe 'Directive: typeBadge', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/typeBadge/typeBadge.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<type-badge></type-badge>'
    element = $compile(element) scope
    scope.$apply()
    expect(element.text()).toBe 'this is the typeBadge directive'

