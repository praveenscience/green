'use strict'

angular.module 'greenApp'
.service 'certificateData', ($http) ->

  create: (certificate) ->
    $http
      url: '/api/certificates'
      method: 'POST'
      data: certificate

  update: (certificate) ->
    $http
      url: "/api/certificates/#{certificate._id}"
      method: 'PUT'
      data: certificate

  remove: (certificateId) ->
    $http
      url: "/api/certificates/#{certificateId}"
      method: 'DELETE'

  show: (certificateId) ->
    $http
      url: "/api/certificates/#{certificateId}"
      method: 'GET'

  get: ->
    $http
      url: '/api/certificates'
      method: 'GET'

