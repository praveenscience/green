###!
Waypoints Sticky Element Shortcut - 3.1.1
Copyright © 2011-2015 Caleb Troughton
Licensed under the MIT license.
https://github.com/imakewebthings/waypoints/blog/master/licenses.txt
###

do ->

  Sticky = (options) ->
    @options = $.extend({}, Waypoint.defaults, Sticky.defaults, options)
    @element = @options.element
    @$element = $(@element)
    @createWrapper()
    @createWaypoint()
    return

  'use strict'
  $ = window.jQuery
  Waypoint = window.Waypoint

  ### Private ###

  Sticky::createWaypoint = ->
    originalHandler = @options.handler
    @waypoint = new Waypoint($.extend({}, @options,
      element: @wrapper
      handler: $.proxy(((direction) ->
        shouldBeStuck = @options.direction.indexOf(direction) > -1
        wrapperHeight = if shouldBeStuck then @$element.outerHeight(true) else ''
        wrapperWidth = if shouldBeStuck then @$element.outerWidth(true) else ''
        @$wrapper.height wrapperHeight
        @$wrapper.width wrapperWidth
        @$element.toggleClass @options.stuckClass, shouldBeStuck
        if originalHandler
          originalHandler.call this, direction
        return
      ), this)))
    return

  ### Private ###

  Sticky::createWrapper = ->
    @$element.wrap @options.wrapper
    @$wrapper = @$element.parent()
    @wrapper = @$wrapper[0]
    return

  ### Public ###

  Sticky::destroy = ->
    if @$element.parent()[0] == @wrapper
      @waypoint.destroy()
      @$element.removeClass(@options.stuckClass).unwrap()
    return

  Sticky.defaults =
    wrapper: '<div class="sticky-wrapper" />'
    stuckClass: 'stuck'
    direction: 'down right'
  Waypoint.Sticky = Sticky
  return
