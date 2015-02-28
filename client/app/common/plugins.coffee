### Implement bootstrap tooltip activation based on scope data, not DOM events ###

angular.module('greenApp').config ($tooltipProvider) ->
  $tooltipProvider.setTriggers 'openTrigger': 'closeTrigger'
  return

angular.module('greenApp').directive 'popPopup', ->
  {
    restrict: 'EA'
    replace: true
    scope:
      title: '@'
      content: '@'
      placement: '@'
      animation: '&'
      isOpen: '&'
    templateUrl: 'template/popover/popover.html'
  }

angular.module('greenApp').directive 'pop', ($tooltip, $timeout) ->
  # Create a tooltop directive with the ui-bootstrap $tooltip service
  tooltip = $tooltip('pop', 'pop', 'openTrigger')
  compile = angular.copy(tooltip.compile)
  # register a custom compile function on our directive which decorates the stock compile fn

  tooltip.compile = (element, attrs) ->
    # Invoke the parent compile function to receive the parent linkFn
    parentLinkFn = compile(element, attrs)
    (scope, element, attrs) ->
      attrs.$observe 'popShow', (val) ->
        showhide = JSON.parse(val)
        $timeout ->
          element.triggerHandler if showhide then 'openTrigger' else 'closeTrigger'
          return
        return
      # invoke the parent link fn
      parentLinkFn scope, element, attrs
      return

  tooltip

