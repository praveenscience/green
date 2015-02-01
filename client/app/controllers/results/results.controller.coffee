'use strict'

angular.module 'greenApp'
.controller 'ResultsCtrl', ($scope, $routeParams, formData, Utils) ->
  formId = $routeParams.id
  $scope.results = []

  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.init = ->
    _loadData()

  _loadData = ->
    formData.results(formId)
      .success (data, status) ->
        $scope.results = data




  $scope.init()
