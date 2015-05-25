'use strict'

describe 'Filter: common', ->

  # load the filter's module
  beforeEach module 'greenApp'

  # initialize a new instance of the filter before each test
  common = undefined
  beforeEach inject ($filter) ->
    common = $filter 'common'

  it 'should return the input prefixed with \'common filter:\'', ->
    text = 'angularjs'
    expect(common text).toBe 'common filter: ' + text
