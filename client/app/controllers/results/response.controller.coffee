'use strict'

angular.module 'greenApp'
.controller 'ResponseCtrl', ($scope, $routeParams, formData, Utils) ->

  formId = $routeParams.id
  resId = $routeParams.res

  $scope.results = []

  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.init = ->
    _loadData()

  _loadData = ->
    formData.results(formId)
      .success (data, status) ->
        $scope.results = data




  $scope.init()
