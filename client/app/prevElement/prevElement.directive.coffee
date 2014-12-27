'use strict'

angular.module 'greenApp'
.directive 'prevElement', ->
  templateUrl: 'app/prevElement/prevElement.html'
  restrict: "E"
  replace: true
  scope:
    field: "="
  controller: ($scope) ->
    $scope.findMax = (array) ->
      max = _.max(array, (a) ->
          return a.points
        )
      return max.points
