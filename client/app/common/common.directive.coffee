'use strict'

angular.module 'greenApp'
.directive 'lastSave', ->
  replace: true
  scope:
    buttonEnabled: "="
    updated: "="
    savedtext: "@"
  controller: ($scope, Utils) ->
    $scope.getFormatedDate = Utils.getFormatedDate
    if $scope.savedtext is undefined
      $scope.savedtext = "Saved!"
  template: """
    <span class="last-save-text text-muted">
      <span ng-if='buttonEnabled'  tooltip-append-to-body="true"  tooltip="Last Saved on: {{getFormatedDate(updated)}}" tooltip-position="left"> {{savedtext}} </span>
      <span ng-if='!buttonEnabled'  tooltip-append-to-body="true"  tooltip="Last Saved on: {{getFormatedDate(updated)}}" tooltip-position="left"> Changes must be saved!</span>
    </span>
  """
