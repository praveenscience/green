'use strict'

angular.module 'greenApp'
.service 'sectionData', ($http) ->
  create: (section) ->
    $http
      url: "api/sections/#{section._id}/edit"
      method: 'PUT'
      data: section
    .success( (data, status) ->
      console.log data
    )
