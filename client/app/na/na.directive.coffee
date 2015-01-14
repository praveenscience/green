'use strict'

angular.module 'greenApp'
.directive 'na', ->
  templateUrl: 'app/na/na.html'
  restrict: 'EA'
  link: (scope, element, attrs) ->
