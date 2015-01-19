'use strict'

angular.module 'greenApp'
.controller 'ResultsCtrl', ($scope, $routeParams, formData) ->
  formId = $routeParams.id

  $scope.init = ->
    formData.results(formId)
      .success (data, status) ->
        console.log data



  $scope.init()
