'use strict'

angular.module 'greenApp'
.filter 'nl2br', ['$sce', ($sce) ->
  return (text) -> $sce.trustAsHtml(text.replace(/\n/g, '<br/>'))
]
