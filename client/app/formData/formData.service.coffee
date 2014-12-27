'use strict'

angular.module 'greenApp'
.service 'formData', ($http) ->
  # AngularJS will instantiate a singleton by calling 'new' on this function
  update: (form) ->
    $http
      url: "api/forms/#{form._id}"
      method: 'PUT'
      data: form

