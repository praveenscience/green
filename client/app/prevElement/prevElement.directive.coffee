'use strict'

angular.module 'greenApp'
.directive 'prevElement', ->
  templateUrl: 'app/prevElement/prevElement.html'
  restrict: "E"
  replace: true
  scope:
    field: "="
    page: "="
    section: "="
  controller: ($scope, Auth) ->
    $scope.isAdmin = Auth.isAdmin
    console.log $scope.isAdmin()
    $scope.$watch('field', (old, newValue) ->
      if !$scope.isAdmin()
        conditionOption = _.find newValue.choices, (v) -> v.is_condition is true
        if(conditionOption)
          fieldIndex = _.find $scope.section.fields, (v) ->
            v._id is conditionOption.show_field

          console.log fieldIndex

          fieldIndex.has_condition = false

          # console.log $scope.section.fields[fieldIndex]

    , true)

    # $scope.showConditionalField = (field, section) ->
      # showField = false




      # if field.has_condition
      #   condField = _.find section.fields, (val) ->
      #     val._id = field.condition.field

      #   condChoice = _.find condField.choices, (v) ->
      #     v._id = field.condition.choice

      #   console.log condField
      #   console.log field.condition.choice

      #   if condField.response is field.condition.choice
      #     console.log "Response is..."
      #     console.log condField
      #     showField = true

      # return !$scope.formShow or !field.has_condition

    $scope.findMax = (array) ->
      max = _.max(array, (a) ->
          return a.points
        )
      return max.points
