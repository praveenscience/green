'use strict'

angular.module 'greenApp'
.controller 'CreateController', ($scope, $http, $routeParams, sectionData, formData, SweetAlert, Auth, Utils) ->

  $scope.isAdmin = Auth.isAdmin
  $scope.formShow = false

  formId = $routeParams.id
  $scope.originalForm = {}
  $scope.form = []
  $scope.sections = []
  $scope.sectionSaving = false
  $scope.enableSaveButton = true
  $scope.formSaving = false
  $scope.isCollapsed = true

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
    label: 'Untitle question'
    help_text: ''
    type: 'text'
    required: ''
    sequence: 0
    edit_mode: true
    is_bonus: false
    has_condition: false
    condition:
      field: ''
      choice: ''
    choices: [
      label: "Option"
      points: 0
      focus: true
      is_condition: false
      show_field: ''
    ]
    field_validation:
      is_required: false
      type: ''
      category: ''
      data: ''
      message: ''

  # Choices
  choice =
    label: "Option"
    points: 0
    focus: true
    is_condition: false
    show_field: ''

  customChoices =
    N:
      label: 'No'
      focus: true
      is_condition: false
      show_field: ''
      points: 0
    Y:
      label: 'Yes'
      focus: true
      is_condition: false
      show_field: ''
      points: 1
    NE:
      label: 'Never or None'
      focus: true
      is_condition: false
      show_field: ''
      points: 1
    A:
      label: 'Always or All'
      focus: false
      is_condition: false
      show_field: ''
      points: 1
    S:
      label: 'Sometimes or Some'
      focus: false
      is_condition: false
      show_field: ''
      points: 1
    NA:
      label: 'Not Applicable'
      focus: false
      is_condition: false
      show_field: ''
      points: 0

  $scope.sortableOptions =
    containment: "parent"
    stop: (e, ui) ->

  $scope.getFormatedDate = (date) ->
    d = new Date(date)
    d.toUTCString()

  $scope.pluralize = (points) ->
    if points == 1
      'point'
    else
      'points'

  $scope.findMaxPoints = (array) ->
    max = _.max(array, (a) -> return a.points)
    max.points

  $scope.calculateSecitonPoints = ->
    return if $scope.form.sections is undefined
    for skey, sval of $scope.form.sections
      $scope.form.sections[skey].bonus_points = 0
      $scope.form.sections[skey].possible_points = 0
      for key, fld of sval.fields
        if $scope.form.sections[skey].fields[key].is_bonus
          $scope.form.sections[skey].bonus_points += $scope.findMaxPoints(fld.choices)
        else
          $scope.form.sections[skey].possible_points += $scope.findMaxPoints(fld.choices)
    return

  $scope.init = ->
    return unless formId
    $scope.getCurrenForm()

  $scope.getCurrenForm = ->
    $http.get("api/forms/#{formId}")
      .success (data) ->
        $scope.originalForm = angular.copy(data)
        $scope.form = data

  $scope.addSectionToForm = (section, formId) ->
    $http.put("api/forms/s/#{formId}", {
        sections: section._id
      }).success (data, status) ->
        $scope.form.sections.push(section)

  $scope.removeSection = (section) ->
    SweetAlert.swal(Utils.getAlertSettings('section'), (isConfirm) ->
      _handleSectionDelete(isConfirm, section))

  _handleSectionDelete = (isConfirm, section) ->
    if (isConfirm)
      sectionData.delete(formId, section)
      .success (data, status) ->
        $scope.form.sections.splice($scope.form.sections.indexOf(section), 1)

  $scope.addNewSection = ->
    newSection = {
      title: $scope.newSection
    }

    return if $scope.newSection is ''
    $http.post('/api/sections', newSection)
      .success( (data, status, headers, config) ->
        $scope.addSectionToForm(data, formId)
        return
      )
    return

  $scope.loadSection = (section) ->
    section.active = true

  $scope.addField = (section) ->
    section.fields.push angular.copy(field)

  $scope.addCustomField = (section, opts, type) ->
    optionsArr = opts.split('-')
    options = []
    optionsArr.forEach (i) ->
      options.push(customChoices[i])
    newField = angular.copy(field)
    newField.type = type
    newField.choices = options
    section.fields.push angular.copy(newField)

  $scope.removeField = (field, section) ->
    currentField = section.fields.indexOf(field)
    section.fields.splice(currentField, 1)

  $scope.toggleField = (field, section) ->
    field.edit_mode = !field.edit_mode;
    $scope.submitSection(section)

  $scope.isValidField = (field) ->
    field.label not in [undefined, '', null] and field.type not in ['', undefined]

  $scope.addChoice = (field) ->
    field.choices = [] if field.choices is undefined
    field.choices.push angular.copy(choice)

  $scope.removeChoice = (field, index) ->
    field.choices.splice index, 1

  $scope.submitSection = (section, sectionId) ->
    $scope.sectionSaving = true
    sectionData.create(section)
      .success (data, status) ->
        section = data
        $scope.sectionSaving = false
        $scope.enableSaveButton = true

  $scope.submitForm = (form) ->
    $scope.formSaving = true
    formData.update(form)
      .success (data, status) ->
        $scope.formSaving = false

  $scope.$watch('form.sections', (old, newValue) ->
    $scope.enableSaveButton = false
    $scope.calculateSecitonPoints()
  , true)

  $scope.init()
