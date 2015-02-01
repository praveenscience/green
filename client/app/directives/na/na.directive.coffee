'use strict'

angular.module 'greenApp'
.directive 'na', ->
  templateUrl: 'app/directives/na/na.html'
  restrict: 'EA'
  link: (scope, element, attrs) ->
