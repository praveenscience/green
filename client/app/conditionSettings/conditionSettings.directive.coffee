'use strict'

angular.module 'greenApp'
.directive 'conditionSettings', ->
  templateUrl: 'app/conditionSettings/conditionSettings.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->
    scope.$watch ->
      scope.$parent.field
    , (a, b) ->
      return if scope.$parent.section is undefined or scope.$parent.section.fields.length is 0

      condField = _.find scope.$parent.section.fields, (val) ->
        val._id is b.condition.field

      if condField != undefined
        for i, val of condField.choices
          condField.choices[i].is_condition = false
          condField.choices[i].show_field = ''

        option = _.find condField.choices, (v) ->
          v._id is b.condition.choice

        option.is_condition = true
        option.show_field = b.condition.field

    , true
