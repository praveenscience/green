'use strict'

angular.module 'greenApp'
.filter 'nl2br', ['$sce', ($sce) ->
  return (text) -> $sce.trustAsHtml(text.replace(/\n/g, '<br/>'))
]

angular.module 'greenApp'
  .filter 'addTargetBlank', [ ->
    (x) ->
      tree = angular.element('<span>' + x + '</span>')
      tree.find('a').attr 'target', '_blank'
      angular.element('<span>').append(tree).html()
    ]

