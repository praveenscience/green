'use strict'

angular.module 'greenApp'
.controller 'CreateController', ($scope, $http, $routeParams, sectionData, formData, SweetAlert, Auth, Utils, $modal, $location, $timeout) ->

  $scope.isAdmin = Auth.isAdmin
  $scope.formShow = false

  formId = $routeParams.id
  $scope.originalForm = {}
  $scope.form = []
  $scope.sections = []
  $scope.sectionSaving = false
  $scope.enableSaveButton = true
  $scope.formSaving = false
  $scope.enableFormSaveButton = true
  $scope.formSettings =
    active: false

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
      label: "Option"
      points: 0
      focus: true
      is_condition: false
      show_field: ''
      is_na: false
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
    is_na: false

  customChoices =
    N:
      label: 'No'
      focus: true
      is_condition: false
      show_field: ''
      points: 0
      is_na: false
    Y:
      label: 'Yes'
      focus: true
      is_condition: false
      show_field: ''
      points: 1
      is_na: false
    NE:
      label: 'Never or None'
      focus: true
      is_condition: false
      show_field: ''
      points: 1
      is_na: false
    A:
      label: 'Always or All'
      focus: false
      is_condition: false
      show_field: ''
      points: 1
      is_na: false
    S:
      label: 'Sometimes or Some'
      focus: false
      is_condition: false
      show_field: ''
      points: 1
      is_na: false
    NA:
      label: 'Not Applicable'
      focus: false
      is_condition: false
      show_field: ''
      points: 0
      is_na: true

  $scope.sortableOptions =
    containment: "parent"
    stop: (e, ui) ->
      $scope.fixSequence()

  $scope.getFormatedDate = Utils.getFormatedDate
  $scope.pluralize = Utils.pluralize

  $scope.findMaxPoints = (array) ->
    max = _.max(array, (a) -> return a.points)
    max.points

  $scope.calculateSecitonPoints = ->
    return if $scope.form.sections is undefined
    for skey, sval of $scope.form.sections
      $scope.form.sections[skey].bonus_points = 0
      $scope.form.sections[skey].possible_points = 0
      for key, fld of sval.fields
        if $scope.form.sections[skey].fields[key].type not in ['text', 'textarea']
          max = $scope.findMaxPoints(fld.choices)
          $scope.form.sections[skey].fields[key].possible_points = max
          if max isnt 'NaN'
            if $scope.form.sections[skey].fields[key].is_bonus
              $scope.form.sections[skey].bonus_points += max
            else
              $scope.form.sections[skey].possible_points += max
    return

  $scope.updateFormPoints = ->
    return if !$scope.form.sections
    $scope.form.total_points = 0
    for section, key in $scope.form.sections
      $scope.form.total_points += (section.possible_points + section.bonus_points)

  $scope.init = ->
    return unless formId
    $scope.getCurrenForm()

  $scope.getCurrenForm = ->
    $http.get("api/forms/#{formId}")
      .success (data) ->
        $scope.originalForm = angular.copy(data)
        $scope.form = data
        $scope.seciton = $scope.form.sections[0]

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
    $scope.seciton = section
    $scope.formSettings.active = false

  $scope.loadFormSettings = ->
    $scope.form.sections.forEach (val) -> val.active = false
    $scope.formSettings.active = true

  $scope.fixSequence = ->
    if $scope.seciton.fields.length isnt 0
      $scope.seciton.fields.forEach (field, index) ->
        field.sequence = index

  $scope.addField = (section) ->
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
    field.choices.push angular.copy(choice)

  $scope.removeChoice = (field, index) ->
    field.choices.splice index, 1

  $scope.submitSection = (section, sectionId) ->
    $scope.sectionSaving = true
    sectionData.create(section)
      .success (data, status) ->
        currentSectionIndex =  _.findIndex $scope.form.sections, (v) -> v._id is sectionId
        $scope.form.sections[currentSectionIndex].fields = angular.copy(data.fields)
        $scope.submitForm($scope.form)

        $timeout ->
          $scope.sectionSaving = false
          $scope.enableSaveButton = true
        , 100

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
        $location.path('#/forms')

  $scope.unPublishForm = ->
    $scope.form.status = 'Unpublished'
    $scope.submitForm($scope.form)

  $scope.attachCertificate = ->
    modalInstance = $modal.open
      windowClass: 'modal-full'
      templateUrl: '/app/controllers/certificate/attach.certificate.html'
      controller: 'AttachcertificateCtrl'
      resolve:
        selectedCertificates: -> $scope.form.certificates

    modalInstance.result.then (certificates) ->
      $scope.form.certificates = certificates
      $scope.submitForm $scope.form

  $scope.$watch('form.sections', (old, newValue) ->
    $scope.enableSaveButton = false
    $scope.calculateSecitonPoints()
    $scope.updateFormPoints()
  , true)

  $scope.$watch('form', (old, newValue) ->
    $scope.enableFormSaveButton = false
  , true)

  $scope.init()
