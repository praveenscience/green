'use strict'

angular.module 'greenApp'
.directive 'fieldElement', ->
  templateUrl: 'app/directives/fieldElement/fieldElement.html'
  replace: true
  # scope:
  #   field: "="
  #   section: '='
  link: (scope, element, attrs) ->
    # scope.selectedField = null

    scope.selectedField = _.find(scope.section.fields, (val) ->
        val._id is scope.field.condition.field
      )

    scope.availableFields = _.filter(scope.section.fields, (val) ->
        return val.type in ['radiobutton', 'select', 'checkbox']) and val._id != scope.field._id
