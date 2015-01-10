'use strict'

angular.module 'greenApp'
.directive 'conditionSettings', ->
  templateUrl: 'app/conditionSettings/conditionSettings.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->
