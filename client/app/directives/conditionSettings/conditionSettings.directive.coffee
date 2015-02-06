'use strict'

angular.module 'greenApp'
.directive 'conditionSettings', ->
  templateUrl: 'app/directives/conditionSettings/conditionSettings.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->

    scope.watchOptionsChange = (field, section) ->
      return if section is undefined or section.fields.length is 0 or field.condition.choice is ''
      condField = _.find section.fields, (val) ->
        val._id is field.condition.field
      condFieldIndex = section.fields.indexOf(condField)

      if condField
        for i, val of section.fields[condFieldIndex].choices
          if val._id in field.condition.choice
            section.fields[condFieldIndex].choices[i].is_condition = true
            section.fields[condFieldIndex].choices[i].show_field = field._id
          else
            section.fields[condFieldIndex].choices[i].is_condition = false
            section.fields[condFieldIndex].choices[i].show_field = ''
