'use strict'

angular.module 'greenApp'
.controller 'FormsController', ($scope, $http, socket, $location) ->

  $scope.forms = []

  $http.get('/api/forms').success (forms) ->
    $scope.forms = forms
    socket.syncUpdates 'form', $scope.forms

  $scope.addform = ->
    return if $scope.newform is ''
    $http.post('/api/forms',
      name: "My new form!!"
    ).success( (data, status, headers, config) ->
      $scope.newform = ''
      $location.path("/forms/edit/#{data._id}")
      return
    )
    return

  $scope.deleteform = (form) ->
    $http.delete '/api/forms/' + form._id

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'form'


