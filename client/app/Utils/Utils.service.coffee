'use strict'

angular.module 'greenApp'
.service 'Utils', ->
  # AngularJS will instantiate a singleton by calling 'new' on this function

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
    d.toUTCString()

  pluralize: (points) ->
    if points == 1
      'point'
    else
      'points'
