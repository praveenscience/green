'use strict'

angular.module 'greenApp'
.service 'sectionData', ($http) ->
  create: (section) ->
    console.log section
    $http
      url: "api/sections/#{section._id}/edit"
      method: 'PUT'
      data:
        data: section
    .success( (data, status) ->
      console.log data
    )
