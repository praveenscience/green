'use strict'

angular.module 'greenApp'
.controller 'FormshowSuccessCtrl', ($scope, $http, $routeParams, formData, Auth, $location) ->

  $scope.form = {}
  $scope.results = null
  formId = $routeParams.id
  resultId = $routeParams.res
  $scope.certificate = null

  $scope.totalPoints = 0
  $scope.aquiredPoints = 0
  $scope.isAdmin = Auth.isAdmin

  $scope.formattedDate = ->
    date = new Date()
    return date.toUTCString().substr(5, 11)

  $scope.init = ->
    _loadFormData()

  _loadFormData = ->
    formData.getForm(formId)
      .success (data, status) ->
        formData.getFormUserResponse(resultId)
          .success (results, resultsStatus) ->
            $scope.results = results
            $scope.form = data
            $scope.certificate = results[0].certificate


  $scope.init()
