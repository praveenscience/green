'use strict'

angular.module 'greenApp'
.directive 'prevElement', ->
  templateUrl: 'app/prevElement/prevElement.html'
  restrict: "E"
  replace: true
  # scope:
  #   field: "="
  #   state: "="
  controller: ($scope, Auth) ->
    $scope.isAdmin = Auth.isAdmin

    $scope.findMax = (array) ->
      max = _.max(array, (a) ->
          return a.points
        )
      return max.points
