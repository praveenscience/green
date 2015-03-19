'use strict'
angular.module 'greenApp'
.service 'Utils', ->

  getAlertSettings: (item) ->
    title: "Are you sure?",
    text: "You will not be able to recover this #{item}!",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes, delete it!",
    cancelButtonText: "No, cancel!",
    closeOnConfirm: true,
    closeOnCancel: true

  getFormatedDate: (date) ->
    d = new Date(date)
    format = d3.time.format("%b %d, %Y at %I:%M %p");
    format(d)

  pluralize: (points) ->
    if points == 1
      'point'
    else
      'points'
