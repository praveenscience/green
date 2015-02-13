'use strict'

angular.module 'greenApp'
.controller 'FormshowCtrl', ($scope, $http, $routeParams, formData, Auth, $location) ->

  $scope.form = {};
  formId = $routeParams.id
  resultId = $routeParams.res
  $scope.page = true
  TOTAL_POINTS = 0

  $scope.totalPoints = 0
  $scope.aquiredPoints = 0
  $scope.isAdmin = Auth.isAdmin

  $scope.init = ->
    _loadFormData()

  _loadFormData = ->
    formData.getForm(formId)
      .success (data, status) ->
        if !Auth.isAdmin()
          if resultId != undefined
            formData.getFormUserResponse(resultId)
              .success (results, resultsStatus) ->
                if results.length != 0
                  _formatForm(data, results)
          else
            $scope.form = data
            TOTAL_POINTS = $scope.form.total_points
            $scope.form.aquired_points = 0
            $scope.form.sections[0].active = true
        else
          $scope.form = data
          $scope.form.aquired_points = 0
          $scope.form.sections[0].active = true

  _formatForm = (data, results) ->
    form = data
    form.results_id = results[0]._id
    for index, field of results[0].results
      section = _.find form.sections, (s) -> s._id is field.section_id
      secField = _.find section.fields, (s) -> s._id is field.field_id


      if field.field_type is 'checkbox'
        for index, choice of field.response
          choiceI = _.find secField.choices, (s) ->
            s._id is choice
          if choiceI
            choiceI.selected = true
            console.log choiceI._id
            _showHiddenField(field.field_id, choiceI._id, section)

      else if field.response != ''
        secField.response = field.response
        # _showHiddenField(field.field_id, field.response, section)

    $scope.form = form
    $scope.form.aquired_points = results[0].points
    $scope.form.sections[0].active = true

  _showHiddenField = (fieldId, response, section) ->
    return if !fieldId

    fieldTobeShown = _.find section.fields, (v) ->
      console.log v.condition.choice
      v.has_condition is true and response in v.condition.choice

    if fieldTobeShown
      fieldTobeShown.has_condition = false

  _updateScore = (field, section) ->
    if field.type in ['checkbox']
      selectdOption = _.find field.choices, (v) ->
        v.selected is true
    else
      selectdOption = _.find field.choices, (v) ->
        field.response is v._id

    if selectdOption instanceof Array
      selectdOption.map (a, b) -> a.points + b.points
    else
      field.aquired_points = 0
      if selectdOption != undefined
        if selectdOption.is_na is true
          field.is_na_reduced = field.possible_points
          $scope.form.total_points = $scope.form.total_points - field.possible_points
        else
          $scope.form.total_points = $scope.form.total_points + (field.is_na_reduced || 0)
          field.is_na_reduced = 0

        field.aquired_points = selectdOption.points

    _updateSectionScore(section)

  _updateSectionScore = (section) ->
    section.aquired_points = 0
    for field, key in section.fields
      if field.aquired_points
        section.aquired_points+= field.aquired_points
    _updateFormScore()

  _updateFormScore = ->
    return if !$scope.form.sections
    $scope.form.aquired_points = 0
    for section, key in $scope.form.sections
      if section.aquired_points
        $scope.form.aquired_points += section.aquired_points

  $scope.watchResponses = (field, section) ->
    _updateScore(field, section)
    if !Auth.isAdmin()
      conditionOption = _.find field.choices, (v) ->
        if field.type in ['checkbox']
          v.selected is true and v.is_condition is true
        else
          v.is_condition is true and field.response is v._id

      if(conditionOption)
        fieldIndex = _.find section.fields, (v) ->
          v._id is conditionOption.show_field
        if fieldIndex

          fieldIndex.has_condition = false
      else
        for i, val of section.fields
          if val.condition.field is field._id
            val.has_condition = true
            val.response = ''

  $scope.toggleClass = (section) ->
    for key, val of $scope.form.sections
      $scope.form.sections[key].active = false
    section.active = true

  $scope.moveToNextStep = ($index, section) ->
    for key, val of $scope.form.sections
      $scope.form.sections[key].active = false
    $scope.form.sections[$index + 1].active = true

  $scope.saveFormResuts = (e) ->
    e.preventDefault()
    $scope.formSaving = true
    formData.respond($scope.form)
      .success (data, status) ->
        $scope.formSaving = false
        if resultId is undefined
          $location.path("#{$location.path()}/#{data._id}")
        if data.submitted is true
          $location.path("#{$location.path()}/success")

  $scope.init()
