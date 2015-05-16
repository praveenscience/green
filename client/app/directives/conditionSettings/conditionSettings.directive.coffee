'use strict'

angular.module 'greenApp'
.directive 'conditionSettings', ->
  templateUrl: 'app/directives/conditionSettings/conditionSettings.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->

    scope.removeAddedField = (field, section) ->
      condField = _.find section.fields, (val) ->
        val._id is field.condition.field
      condFieldIndex = section.fields.indexOf(condField)
      if condField
        for i, val of section.fields[condFieldIndex].choices
          choice = section.fields[condFieldIndex].choices[i]
          choice.show_field.splice(choice.show_field.indexOf(field._id), 1)
          if choice.show_field.length is 0
              choice.is_condition = false

    scope.watchOptionsChange = (field, section) ->
      return if section is undefined or section.fields.length is 0 or field.condition.choice is ''
      condField = _.find section.fields, (val) ->
        val._id is field.condition.field
      condFieldIndex = section.fields.indexOf(condField)

      if condField
        for i, val of section.fields[condFieldIndex].choices
          choice = section.fields[condFieldIndex].choices[i]
          if val._id in field.condition.choice
            section.fields[condFieldIndex].choices[i].is_condition = true
            if section.fields[condFieldIndex].choices[i].show_field.indexOf(field._id) < 0
              section.fields[condFieldIndex].choices[i].show_field.push(field._id)
          else
            if choice.show_field.length is 0
              section.fields[condFieldIndex].choices[i].is_condition = false
