'use strict'

angular.module 'greenApp'
.directive 'lastSave', ->
  template: """
    <span class="last-save-text text-muted">
    <span ng-if='enableSaveButton'  tooltip-append-to-body="true"  tooltip="Last Saved on: {{getFormatedDate(section.updated)}}" tooltip-position="left"> Saved!</span>
    <span ng-if='!enableSaveButton'  tooltip-append-to-body="true"  tooltip="Last Saved on: {{getFormatedDate(section.updated)}}" tooltip-position="left"> Changes must be saved!</span>
    </span>
  """

.directive 'focusOnShow', ($timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    $timeout ->
      element[0].select()

