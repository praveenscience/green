'use strict'

angular.module 'greenApp'
.directive 'focusOnShow', ($timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    $timeout ->
      element[0].select()

