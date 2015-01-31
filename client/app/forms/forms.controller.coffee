'use strict'

angular.module 'greenApp'
.controller 'FormsController', ($scope, $http, socket, $location, Auth, SweetAlert, Utils) ->

  $scope.isAdmin = Auth.isAdmin
  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.forms = []
  $scope.submissions = []

  $scope.isActive = (route) ->
    route is $location.path()

  $scope.currentForm = []

  $scope.init = ->
    _loadFroms()
    if !Auth.isAdmin()
      _loadSubmissions()

  _loadSubmissions = ->
    $http.get('/api/results/submissions').success (forms) ->
      $scope.submissions = forms

  _loadFroms = ->
    $http.get('/api/forms').success (forms) ->
      $scope.forms = forms
      socket.syncUpdates 'form', $scope.forms

  $scope.addform = ->
    return if $scope.newform is ''

    formSkl =
      name: 'Untitled form'
      status: 'Unpublished'
      certificates: []
      sections: [{
        title: "Untitled section"
        fields: [{
          label: "Add question text"
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

  $scope.slideInFormDetails = (curform) ->
    console.log curform
    $scope.currentForm = curform

  $scope.getFormLink = (form) ->
    if $scope.isAdmin() and form.status is 'Unpublished'
      return "/forms/edit/#{form._id}"
    else if $scope.isAdmin() and form.status is 'Published'
      return "/results/#{form._id}"
    else
      return "/forms/#{form._id}"

  $scope.removeForm = (form) ->
    SweetAlert.swal(Utils.getAlertSettings('form'), (isConfirm) ->
      _handleFormDelete(isConfirm, form))

  $scope.removeResult = (result) ->
    SweetAlert.swal(Utils.getAlertSettings('result'), (isConfirm) ->
      _handleResultDelete(isConfirm, result))

  _handleResultDelete = (isConfirm, result) ->
    $http.delete "/api/results/#{result._id}"

  _handleFormDelete = (isConfirm, form) ->
    if isConfirm
      $http.delete "/api/forms/#{form._id}"

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'form'

  $scope.init()


