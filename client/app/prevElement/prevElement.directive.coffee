'use strict'

angular.module 'greenApp'
.directive 'prevElement', ->
  templateUrl: 'app/prevElement/prevElement.html'
  restrict: "E"
  replace: true
  scope:
    field: "="
