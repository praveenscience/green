'use strict'

angular.module 'greenApp'
.controller 'FormsController', ($scope, $http, socket, $location, Auth) ->

  $scope.isAdmin = Auth.isAdmin

  $scope.getFormatedDate = (date) ->
    d = new Date(date)
    d.toUTCString()

  $scope.forms = []

  $http.get('/api/forms').success (forms) ->
    $scope.forms = forms
    socket.syncUpdates 'form', $scope.forms

  $scope.removeForm = (form) ->
    $http.delete '/api/forms/' + form._id

  $scope.addform = ->
    return if $scope.newform is ''

    formSkl =
      name: 'Untitled form'
      status: 'Unpublished'
      sections: [{
        title: "Untitled section"
        fields: [{
          label: "Untitled filed"
          help_text: 'help text goes here'
          type: 'text'
          required: false
          sequence: 0
          edit_mode: true
          has_condition: false
          condition:
            field: ''
            choice: ''
          choices: [{
            label: "Option 1"
            points: 0
          }]
          field_validation:
            is_required: false
            type: ''
            category: ''
            data: ''
            message: ''
        }]
      }]

    $http.post('/api/forms', formSkl)
      .success( (data, status, headers, config) ->
        $scope.newform = ''
        $location.path("/forms/edit/#{data._id}")
        return
      )
    return

  $scope.deleteform = (form) ->
    $http.delete '/api/forms/' + form._id

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'form'


