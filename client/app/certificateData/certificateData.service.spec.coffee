'use strict'

describe 'Service: certificateData', ->

  # load the service's module
  beforeEach module 'greenApp'

  # instantiate service
  certificateData = undefined
  beforeEach inject (_certificateData_) ->
    certificateData = _certificateData_

  it 'should do something', ->
    expect(!!certificateData).toBe true
