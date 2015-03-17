'use strict'

angular.module 'greenApp'
.controller 'ResultsCtrl', ($scope, $routeParams, formData, Utils) ->
  formId = $routeParams.id
  $scope.results = []
  $scope.form = []
  $scope.stats =
    all: 0
    submitted: 0
    draft: 0

  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.init = ->
    _loadData()
    _loadForm()

  _loadForm = ->
    formData.getForm(formId)
      .success (data, status) ->
        $scope.form = data

  _loadData = ->
    formData.results(formId)
      .success (data, status) ->
        $scope.results = data
        _updateStats()

  _updateStats = ->
    $scope.results.forEach (val) ->
      if val.status is 'draft'
        $scope.stats.draft++

    $scope.stats.all = $scope.results.length
    $scope.stats.submitted = $scope.stats.all - $scope.stats.draft

  $scope.init()
