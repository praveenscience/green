### Implement bootstrap tooltip activation based on scope data, not DOM events ###
# Important this should be added in ui-tpls page
# angular.module("ui.bootstrap.tpls", ["template/popover/popover-close.html", "template/accordion/accordion-group.html","template/accordion/accordion.html","template/alert/alert.html","template/carousel/carousel.html","template/carousel/slide.html","template/datepicker/datepicker.html","template/datepicker/day.html","template/datepicker/month.html","template/datepicker/popup.html","template/datepicker/year.html","template/modal/backdrop.html","template/modal/window.html","template/pagination/pager.html","template/pagination/pagination.html","template/tooltip/tooltip-html-unsafe-popup.html","template/tooltip/tooltip-popup.html","template/popover/popover.html","template/progressbar/bar.html","template/progressbar/progress.html","template/progressbar/progressbar.html","template/rating/rating.html","template/tabs/tab.html","template/tabs/tabset.html","template/timepicker/timepicker.html","template/typeahead/typeahead-match.html","template/typeahead/typeahead-popup.html"]);

angular.module('greenApp').config ($tooltipProvider) ->
  $tooltipProvider.setTriggers 'openTrigger': 'closeTrigger'
  return


angular.module('template/popover/popover-close.html', []).run [
  '$templateCache'
  ($templateCache) ->
    $templateCache.put 'template/popover/popover-close.html', """
      <div class="popover {{placement}}" ng-class="{ in: isOpen, fade: animation() }">
        <div class="arrow"></div>
        <div class="popover-close" ng-click="$parent.$parent.$parent.field.showing_popup = false">&times;</div>
        <div class="popover-inner">
            <h3 class="popover-title" ng-bind="title" ng-show="title"></h3>
            <div class="popover-content" ng-bind="content"></div>
        </div>
      </div>
      """
    return
]

angular.module('greenApp').directive 'popPopup', ->
  {
    restrict: 'EA'
    replace: true
    scope:
      title: '@'
      content: '@'
      placement: '@'
      animation: '&'
      isOpen: '='
    templateUrl: 'template/popover/popover-close.html'
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
        if val
          scope.showhide = JSON.parse(val)
          $timeout ->
            element.triggerHandler if scope.showhide then 'openTrigger' else 'closeTrigger'
            return
        return
      # invoke the parent link fn
      parentLinkFn scope, element, attrs
      return

  tooltip

