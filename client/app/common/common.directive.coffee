'use strict'

angular.module 'greenApp'
.directive 'lastSave', ->
  replace: true
  scope:
    buttonEnabled: "="
    updated: "="
  template: """
    <span class="last-save-text text-muted">
      <span ng-if='buttonEnabled'  tooltip-append-to-body="true"  tooltip="Last Saved on: {{getFormatedDate(updated)}}" tooltip-position="left">Saved!</span>
      <span ng-if='!buttonEnabled'  tooltip-append-to-body="true"  tooltip="Last Saved on: {{getFormatedDate(updated)}}" tooltip-position="left"> Changes must be saved!</span>
    </span>
  """
