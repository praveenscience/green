'use strict'

angular.module 'greenApp'
.controller 'FormsController', ($scope, $http, $location, Auth, SweetAlert, Utils) ->

  $scope.isAdmin = Auth.isAdmin
  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.forms = []
  $scope.submissions = []

  $scope.isActive = (route) ->
    route is $location.path()

  $scope.currentForm = null
  $scope.filt = {}
  $scope.filt.status = "Published"

  $scope.init = ->
    _loadFroms()
    if !Auth.isAdmin()
      _loadSubmissions()

  _loadSubmissions = ->
    $http.get('/api/results/submissions').success (submissions) ->
      $scope.submissions = submissions

  _loadFroms = ->
    $http.get('/api/forms').success (forms) ->
      $scope.forms = forms

  $scope.addform = ->
    return if $scope.newform is ''

    formSkl =
      name: 'Untitled form'
      status: 'Unpublished'
      certificates: []
      no_certificate: ""
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
            seq: 0
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
    $scope.currentForm = curform

  $scope.isExpired = (expires) ->
    now = new Date()
    expiresDate = new Date(expires)
    now > expiresDate

  $scope.getFormLink = (form) ->
    if $scope.isAdmin() and form.status is 'Unpublished'
      return "/forms/edit/#{form._id}"
    else if $scope.isAdmin() and form.status is 'Published'
      return "/results/#{form._id}"
    else
      return "/forms/#{form._id}"

  $scope.getSubmissionLink = (submission) ->
    if submission.status is 'draft'
      "/forms/#{submission.form._id}/#{submission._id}"
    else
      "/results/#{submission.form._id}/#{submission._id}"

  $scope.removeForm = (form, hideSidebar) ->
    SweetAlert.swal(Utils.getAlertSettings('form'), (isConfirm) ->
      _handleFormDelete(isConfirm, form, hideSidebar))

  $scope.removeResult = (result) ->
    SweetAlert.swal(Utils.getAlertSettings('result'), (isConfirm) ->
      _handleResultDelete(isConfirm, result))

  _handleResultDelete = (isConfirm, result) ->
    if isConfirm
      $http.delete "/api/results/#{result._id}"
        .success (data, status) ->
          $scope.submissions.splice($scope.submissions.indexOf(result), 1)

  _handleFormDelete = (isConfirm, form, hideSidebar) ->
    console.log isConfirm
    if isConfirm
      $http.delete "/api/forms/#{form._id}"
        .success (data, status) ->
          $scope.forms.splice($scope.forms.indexOf(form), 1)
          if hideSidebar
            $scope.currentForm = null

  $scope.init()


