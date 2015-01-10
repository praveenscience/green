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

    $scope.selectedField = _.find($scope.section.fields, (val) ->
        val._id is $scope.field.condition.field
      )

    $scope.availableFields = _.filter($scope.section.fields, (val) ->
        return val.type in ['radiobutton', 'select', 'checkbox'])



