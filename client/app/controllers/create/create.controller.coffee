'use strict'

angular.module 'greenApp'
.controller 'CreateController', ($scope, $http, $routeParams, sectionData, formData, SweetAlert, Auth, Utils, $modal, $location, $timeout) ->

  $scope.isAdmin = Auth.isAdmin
  $scope.formShow = false

  formId = $routeParams.id
  $scope.originalForm = {}
  $scope.form = []
  $scope.section = []
  $scope.sections = []
  $scope.sectionSaving = false
  $scope.enableSaveButton = true
  $scope.formSaving = false
  $scope.enableFormSaveButton = true
  $scope.currentChoices = []
  $scope.formSettings =
    active: false

  $scope.fieldTypes = [
    {
      type: 'text'
      name: 'Text'
      icon: 'text'
    }
    {
      type: 'textarea'
      name: 'Paragraph'
      icon: 'paragraph'
    }
    {
      type: 'radiobutton'
      name: 'Radio Buttons'
      icon: 'radio'
    }
    {
      type: 'select'
      name: 'Dropdown'
      icon: 'dropdown'
    }
    {
      type: 'checkbox'
      name: 'Checkboxes'
      icon: 'checkbox'
    }
  ]

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
    label: 'Add question text'
    help_text: ''
    type: 'text'
    required: ''
    sequence: 0
    edit_mode: true
    is_bonus: false
    has_condition: false
    possible_points: 0
    has_na: false
    condition:
      field: ''
      choice: ''
    choices: [
      label: ""
      points: 0
      focus: true
      is_condition: false
      has_helptext: false
      help_text: ''
      show_field: []
      is_na: false
      seq: 0
    ]
    field_validation:
      is_required: false
      type: ''
      category: ''
      data: ''
      message: ''

  # Choices
  choice =
    label: ""
    points: 0
    focus: true
    is_condition: false
    show_field: []
    is_na: false
    has_helptext: false
    help_text: ''
    seq: 0

  customChoices =
    N:
      label: 'No'
      focus: true
      is_condition: false
      show_field: []
      points: 0
      is_na: false
      has_helptext: false
      help_text: ''
      seq: 0
    Y:
      label: 'Yes'
      focus: true
      is_condition: false
      show_field: []
      points: 1
      is_na: false
      has_helptext: false
      help_text: ''
      seq: 0
    NE:
      label: 'Never or None'
      focus: true
      is_condition: false
      show_field: []
      points: 1
      is_na: false
      has_helptext: false
      help_text: ''
      seq: 0
    A:
      label: 'Always or All'
      focus: false
      is_condition: false
      show_field: []
      points: 1
      is_na: false
      has_helptext: false
      help_text: ''
      seq: 0
    S:
      label: 'Sometimes or Some'
      focus: false
      is_condition: false
      show_field: []
      points: 1
      is_na: false
      has_helptext: false
      help_text: ''
      seq: 0
    NA:
      label: 'Not Applicable'
      focus: false
      is_condition: false
      show_field: []
      points: 0
      is_na: true
      has_helptext: false
      help_text: ''
      seq: 0

  $scope.sortableOptions =
    containment: "parent"
    placeholder: "ui-state-highlight"
    stop: (e, ui) ->
      $scope.fixSequence()
      $timeout ->
        $scope.submitCurrentSection()
      , 100

  $scope.optionsSortableOptions =
    containment: 'parent'
    placeholder: 'ui-state-option-highlight'
    handle: '> .choicedraghandle'
    stop: (e, ui) ->
      $scope.currentField = _.find($scope.section.fields, (v) -> v._id == ui.item[0].dataset.field)
      i = 0
      while i < $scope.currentField.choices.length
        $scope.currentField.choices[i].seq = i
        i++
      $timeout ->
        $scope.submitCurrentSection()
      , 500

  $scope.getFormatedDate = Utils.getFormatedDate
  $scope.pluralize = Utils.pluralize

  $scope.findMaxPoints = (array) ->
    max = _.max(array, (a) -> return a.points)
    max.points

  $scope.findSumOfPoints = (array) -> _.sum(array, 'points')

  $scope.calculateSectionPoints = ->
    return if $scope.form.sections is undefined
    for skey, sval of $scope.form.sections
      $scope.form.sections[skey].bonus_points = 0
      $scope.form.sections[skey].possible_points = 0
      for key, fld of sval.fields
        if fld.type not in ['text', 'textarea']
          pts = $scope.findMaxPoints(fld.choices)
          if fld.type is 'checkbox'
            pts = $scope.findSumOfPoints(fld.choices)

          $scope.form.sections[skey].fields[key].possible_points = pts
          if pts isnt 'NaN' and !$scope.form.sections[skey].fields[key].has_condition or $scope.form.sections[skey].fields[key].is_bonus
            if $scope.form.sections[skey].fields[key].is_bonus
              $scope.form.sections[skey].bonus_points += pts
            else
              $scope.form.sections[skey].possible_points += pts
    return

  $scope.updateFormPoints = ->
    return if !$scope.form.sections
    $scope.form.total_points = 0
    for section, key in $scope.form.sections
      $scope.form.total_points += (section.possible_points)

  $scope.init = ->
    return unless formId
    $scope.getCurrenForm()

  $scope.getCurrenForm = ->
    $http.get("api/forms/#{formId}")
      .success (data) ->
        $scope.originalForm = angular.copy(data)
        $scope.form = data
        $scope.section = $scope.form.sections[0]

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
        $scope.newSection = ''
        return
      )
    return

  $scope.loadSection = (section) ->
    section.active = true
    $scope.section = section
    $scope.formSettings.active = false

  $scope.loadFormSettings = ->
    $scope.form.sections.forEach (val) -> val.active = false
    $scope.formSettings.active = true

  $scope.fixSequence = ->
    if $scope.section.fields.length isnt 0
      $scope.section.fields.forEach (field, index) ->
        field.sequence = index

  $scope.fixChoiceSequence = (field) ->
    if field.choices.length isnt 0
      field.choices.forEach (choice, choindex) ->
        choice.seq = choindex

  $scope.addHelptext = (choice) ->
    choice.has_helptext = true

  $scope.removeHelptext = (choice) ->
    choice.has_helptext = false
    choice.help_text = ''

  $scope.addField = (section) ->
    field.sequence = section.fields.length
    formData.addField angular.copy(field)
      .success (data, status) ->
        newField = angular.copy(field)
        newField._id = data._id
        newField.choices[0]._id = data.choices[0]
        section.fields.push angular.copy(newField)
        $scope.fixSequence()

  $scope.addNAChoice = (field) ->
    naField = _.findIndex field.choices, (v) ->
      v.is_na is true
    if naField >= 0
      field.choices.splice naField, 1
      field.has_na = false
    else
      field.has_na = true
      field.choices.push angular.copy(customChoices['NA'])

  $scope.addCustomField = (section, opts, type) ->
    optionsArr = opts.split('-')
    options = []
    optionsArr.forEach (i) ->
      options.push(customChoices[i])
    newField = angular.copy(field)
    newField.type = type
    newField.choices = options
    formData.addField angular.copy(newField)
      .success (data, status) ->
        newField._id = data._id
        section.fields.push angular.copy(newField)
        $scope.fixSequence()

  $scope.removeField = (field, section) ->
    formData.removeField field._id
      .success (data, status) ->
        currentField = section.fields.indexOf(field)
        section.fields.splice(currentField, 1)
        $scope.fixSequence()

  $scope.toggleField = (field, section) ->
    field.edit_mode = !field.edit_mode;
    $scope.submitSection(section, section._id)

  $scope.isValidField = (field) ->
    field.label not in [undefined, '', null] and field.type not in ['', undefined]

  $scope.addChoice = (field) ->
    field.choices = [] if field.choices is undefined
    choice.seq = field.choices.length
    field.choices.push angular.copy(choice)
    $scope.fixChoiceSequence(field)

  $scope.removeChoice = (field, index) ->
    field.choices.splice index, 1
    $scope.fixChoiceSequence(field)

  $scope.submitCurrentSection = ->
    currSection = _.find $scope.form.sections, (v) -> v.active is true
    $scope.submitSection(currSection, currSection._id)

  $scope.submitSection = (section, sectionId) ->
    $scope.sectionSaving = true
    sectionData.create(section)
      .success (data, status) ->
        currentSectionIndex =  _.findIndex $scope.form.sections, (v) -> v._id is sectionId
        fields = _.sortBy(data.fields, 'sequence')
        $scope.form.sections[currentSectionIndex].fields = angular.copy(fields)
        $scope.submitForm($scope.form)
        $timeout ->
          $scope.sectionSaving = false
          $scope.enableSaveButton = true
        , 100

  $scope.removeForm = ->
    SweetAlert.swal(Utils.getAlertSettings('form'), (isConfirm) ->
      _handleFormDelete(isConfirm))

  _handleFormDelete = (isConfirm) ->
    if isConfirm
      $http.delete "/api/forms/#{$scope.form._id}"
        .success (data, status) ->
          $location.path('#/forms')

  $scope.submitForm = (form) ->
    $scope.formSaving = true
    formData.update(form)
      .success (data, status) ->
        $scope.formSaving = false
        $scope.enableFormSaveButton = true

  $scope.publishForm = ->
    $scope.form.status = 'Published'
    $scope.formSaving = true
    formData.update($scope.form)
      .success (data, status) ->
        $scope.formSaving = false
        $scope.enableFormSaveButton = true
        $location.path('/forms')

  $scope.unPublishForm = ->
    $scope.form.status = 'Unpublished'
    $scope.submitForm($scope.form)

  $scope.attachCertificate = ->
    modalInstance = $modal.open
      windowClass: 'modal-full'
      templateUrl: 'app/controllers/certificate/attach_certificate.html'
      controller: 'AttachcertificateCtrl'
      resolve:
        selectedCertificates: -> $scope.form.certificates

    modalInstance.result.then (certificates) ->
      $scope.form.certificates = certificates
      $scope.submitForm $scope.form

  $scope.$watch('form.sections', (old, newValue) ->
    $scope.enableSaveButton = false
    $scope.calculateSectionPoints()
    $scope.updateFormPoints()
  , true)

  $scope.$watch('form', (old, newValue) ->
    $scope.enableFormSaveButton = false
  , true)

  $scope.init()
