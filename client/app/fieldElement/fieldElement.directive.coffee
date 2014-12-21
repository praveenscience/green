'use strict'

angular.module 'greenApp'
.directive 'fieldElement', ->
  templateUrl: 'app/fieldElement/fieldElement.html'
  replace: true
  # scope:
  #   field: "="
