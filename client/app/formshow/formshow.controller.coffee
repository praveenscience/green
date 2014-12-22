'use strict'

angular.module 'greenApp'
.controller 'FormshowCtrl', ($scope, $http, $routeParams) ->

  $scope.form = null;
  formId = $routeParams.id

  $scope.init = ->
    _loadFormData()

  _loadFormData = ->
    $http
      method: "GET"
      url: "/api/forms/#{formId}"
    .success (data, status) ->
      $scope.form = data
      $scope.form.sections[0].active = true

  $scope.toggleClass = (section) ->
    for key, val of $scope.form.sections
      $scope.form.sections[key].active = false

    section.active = true



  $scope.init()
