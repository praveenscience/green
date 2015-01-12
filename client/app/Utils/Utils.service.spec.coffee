'use strict'

describe 'Service: Utils', ->

  # load the service's module
  beforeEach module 'greenApp'

  # instantiate service
  Utils = undefined
  beforeEach inject (_Utils_) ->
    Utils = _Utils_

  it 'should do something', ->
    expect(!!Utils).toBe true
