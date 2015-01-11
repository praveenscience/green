'use strict'

angular.module 'greenApp'
.controller 'FormshowCtrl', ($scope, $http, $routeParams, formData, Auth) ->

  $scope.form = {};
  formId = $routeParams.id
  $scope.formShow = true
  $scope.formSaving = false;

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
      sectionIndex = _.findIndex form.sections, (s) -> s._id is field.section_id
      fieldIndex = _.findIndex form.sections[sectionIndex].fields, (s) -> s._id is field.field_id
      if field.response instanceof Array
        $.each field.response, (index, choice) ->
          choicesId = _.findIndex form.sections[sectionIndex].fields[fieldIndex].choices, (s) -> s._id is choice
          form.sections[sectionIndex].fields[fieldIndex].choices[choicesId].selected = true
      else
        form.sections[sectionIndex].fields[fieldIndex].response = field.response


    $scope.form = form
    $scope.form.sections[0].active = true

    # $scope.$watch('form.sections', (old, newValue) ->


    # , true)



    #$scope.form.sections[0].active = true

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
