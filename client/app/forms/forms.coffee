'use strict'

angular.module 'greenApp'
.config ($routeProvider) ->
  $routeProvider.when '/forms',
    templateUrl: (urlatt) ->
      return 'app/forms/forms.html'
    controller: 'FormsController'
    authenticate: true

