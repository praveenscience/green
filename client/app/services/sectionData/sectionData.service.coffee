'use strict'

angular.module 'greenApp'
.service 'sectionData', ($http) ->
  create: (section) ->
    sec = $http
      url: "api/sections/#{section._id}/edit"
      method: 'PUT'
      data: section
    return sec

  delete: (formId, section) ->
    $http.delete("api/forms/s/#{formId}/#{section._id}")

