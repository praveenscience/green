'use strict'

angular.module 'greenApp'
.controller 'FormshowCtrl', ($scope, $http, $routeParams, formData, Auth) ->

  $scope.form = {};
  formId = $routeParams.id
  $scope.page = true

  $scope.init = ->
    _loadFormData()

  _loadFormData = ->
    formData.getForm(formId)
      .success (data, status) ->
        if !Auth.isAdmin()
          formData.getFormUserResponse(formId)
            .success (results, resultsStatus) ->
              if results.length != 0
                _formatForm(data, results)
              else
                $scope.form = data
                $scope.form.sections[0].active = true
        else
          $scope.form = data
          $scope.form.sections[0].active = true

  _formatForm = (data, results) ->
    form = data
    for index, field of results[0].results
      section = _.find form.sections, (s) -> s._id is field.section_id
      secField = _.find section.fields, (s) -> s._id is field.field_id
      if field.response instanceof Array
        $.each field.response, (index, choice) ->
          choice = _.findIndex secField.choices, (s) ->
            s._id is choice
          choice.selected = true
      else
        if field.response != ''
          secField.response = field.response
          _showHiddenField(field.field_id, field.response, section)

    $scope.form = form
    $scope.form.sections[0].active = true

  _showHiddenField = (fieldId, response,section) ->
    return if !fieldId

    fieldTobeShown = _.find section.fields, (v) ->
      v.has_condition is true and v.condition.choice is response

    if fieldTobeShown
      fieldTobeShown.has_condition = false

  $scope.watchResponses = (field, section) ->
    if !Auth.isAdmin()
      conditionOption = _.find field.choices, (v) ->
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
    # return Auth.isAdmin()
    $scope.formSaving = true
    formData.respond($scope.form)
      .success (data, status) ->
        $scope.formSaving = false

  $scope.init()
