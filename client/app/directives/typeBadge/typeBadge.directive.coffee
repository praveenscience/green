'use strict'

angular.module 'greenApp'
.directive 'typeBadge', ->
  templateUrl: 'app/directives/typeBadge/typeBadge.html'
  restrict: 'EA'
  link: (scope, element, attrs) ->
