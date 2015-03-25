'use strict'

describe 'Service: sectionData', ->

  # load the service's module
  beforeEach module 'greenApp'

  # instantiate service
  sectionData = undefined
  beforeEach inject (_sectionData_) ->
    sectionData = _sectionData_
