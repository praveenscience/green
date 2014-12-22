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
      console.log data
      $scope.form = data;



  $scope.init()
