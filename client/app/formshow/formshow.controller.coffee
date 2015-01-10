'use strict'

angular.module 'greenApp'
.controller 'FormshowCtrl', ($scope, $http, $routeParams, formData, Auth) ->

  $scope.form = null;
  formId = $routeParams.id

  $scope.init = ->
    _loadFormData()

  _loadFormData = ->
    formData.getForm(formId)
      .success (data, status) ->
        formData.getFormUserResponse(formId)
          .success (results, resultsStatus) ->
            #$scope.form = data
            #$scope.form.sections[0].active = true
            _formatForm(data, results)



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


    #$scope.form.sections[0].active = true

  $scope.toggleClass = (section) ->
    for key, val of $scope.form.sections
      $scope.form.sections[key].active = false
    section.active = true

  $scope.saveFormResuts = (e) ->
    e.preventDefault()
    formData.respond($scope.form)

  $scope.init()
