'use strict'

describe 'Directive: prevElement', ->

  # load the directive's module and view
  beforeEach module 'greenApp'
  beforeEach module 'app/prevElement/prevElement.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()
