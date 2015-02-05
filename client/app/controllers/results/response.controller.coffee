'use strict'

angular.module 'greenApp'
.controller 'ResponseCtrl', ($scope, $routeParams, formData, Utils) ->

  formId = $routeParams.id
  resId = $routeParams.res

  $scope.results = []
  $scope.form = null

  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.init = ->
    _loadData()

  _loadData = ->
    formData.getForm(formId)
      .success (data, status) ->
        formData.getFormUserResponse(resId)
          .success (results, status) ->
            _prepareData(data, results)

  _prepareData = (data, results) ->
    $scope.form = data
    console.log data
    console.log results



  $scope.init()
