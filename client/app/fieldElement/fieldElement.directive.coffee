'use strict'

angular.module 'greenApp'
.directive 'fieldElement', ->
  templateUrl: 'app/fieldElement/fieldElement.html'
  replace: true
  scope:
    field: "="
    section: '='
  controller: ($scope) ->
    # $scope.selectedField = null

    $scope.availableFields = _.filter($scope.section.fields, (val) ->
        return val.type in ['radiobutton', 'select', 'checkbox'])


    $scope.updateAvailableFieldChoices = () ->
      setTimeout ->
        console.log $scope.selectedField
      , 10
      $scope.field.condition.field = $scope.selectedField._id




