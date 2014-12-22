'use strict'

angular.module 'greenApp'
.controller 'CreateController', ($scope, $http, $routeParams, sectionData) ->

  formId = $routeParams.id
  $scope.originalForm = {}
  $scope.form = {}
  $scope.sections = []
  $scope.sectionSaving = false
  $scope.enableSaveButton = true

  # Main Form
  master =
    title: ''
    description: ''
    form_type: ''
    results_viewable: true
    template: false
    fields: []

  # Fields
  field =
    label: null
    help_text: ''
    type: ''
    required: ''
    sequence: 0
    edit_mode: true
    choices: [
      label: "Option"
      points: 0
      focus: true
    ]
    field_validation:
      is_required: false
      type: ''
      category: ''
      data: ''
      message: ''

  # Choices
  choice =
    label: ''


  $scope.getFormatedDate = (date) ->
    d = new Date(date)
    d.toUTCString()

  $scope.pluralize = (points) ->
    console.log points
    if points == 1
      'point'
    else
      'points'

  $scope.init = ->
    return unless formId
    $scope.getCurrenForm()

  $scope.getCurrenForm = ->
    $http.get("api/forms/#{formId}")
      .success( (data) ->
        console.log data
        $scope.originalForm = angular.copy(data)
        $scope.form = data
      )

  $scope.addSectionToForm = (sectionId, formId) ->
    $http.put("api/forms/s/#{formId}", {
        sections: sectionId._id
      }).success( (data, status) ->
        console.log data
      )

  $scope.removeSection = (section) ->
    $http.delete("api/forms/s/#{formId}", {
        sections: section._id
      }).success( (data, status) ->
        $scope.form.sections.splice($scope.form.sections.indexOf(section), 1)
        console.log data
      )

  $scope.addNewSection = ->
    newSection = {
      title: $scope.newSection
    }

    return if $scope.newSection is ''
    $http.post('/api/sections', newSection)
      .success( (data, status, headers, config) ->
        $scope.newSection = ''
        $scope.addSectionToForm(data, formId)
        $scope.form.sections.push(newSection)
        return
      )
    return

  $scope.loadSection = (section) ->
    section.active = true

  $scope.addField = (section) ->
    section.fields.push angular.copy(field)

  $scope.removeField = (field, section) ->
    currentField = section.fields.indexOf(field)
    section.fields.splice(currentField, 1)

  $scope.toggleField = (field, section) ->
    field.edit_mode = !field.edit_mode;

  $scope.isValidField = (field) ->
    field.label not in [undefined, '', null] and field.type not in ['', undefined]

  $scope.addChoice = (field) ->
    field.choices = [] if field.choices is undefined
    field.choices.push angular.copy(choice)

  $scope.removeChoice = (field, index) ->
    field.choices.splice index, 1


  $scope.$watch('form.sections', (old, newValue) ->
    $scope.enableSaveButton = false
  , true)

  $scope.submitSection = (section, sectionId) ->
    $scope.sectionSaving = true
    sectionData.create(section)
      .success( (data, status) ->
        $scope.sectionSaving = false
        $scope.enableSaveButton = true
      )

  $scope.init()

  # $http.get '/api/users'
  # .success (users) ->
  #   $scope.users = users

  # $scope.delete = (user) ->
  #   User.remove id: user._id
  #   _.remove $scope.users, user
