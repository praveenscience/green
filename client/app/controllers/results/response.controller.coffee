'use strict'

angular.module 'greenApp'
.controller 'ResponseCtrl', ($scope, $routeParams, formData, Utils, $timeout, $anchorScroll, $location) ->

  formId = $routeParams.id
  resId = $routeParams.res

  $scope.results = []
  $scope.form = null

  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.init = ->
    _loadData()
    _initWaypoints()

  $scope.scrollToSeciton = (index, section) ->
    $('html, body').animate
      scrollTop: document.getElementById("seciton-#{index}").offsetTop + "px"
    1000

    $timeout ->
      $scope.form.sections.forEach (sec) -> sec.active = false
      section.active = true
      $scope.$digest();
    , 0

  _initWaypoints = ->
    $timeout ->
      sticky = new Waypoint.Sticky
        element: $('.fixed-navigation')[0]

      s = $('.response-section').waypoint(
          handler: (direction) -> _updateCurrent(this.element.id.split('-')[1])
          offset: 5
        )
    , 1000

  _updateCurrent = (id) ->
    $scope.form.sections.forEach (sec) -> sec.active = false
    $scope.form.sections[id].active = true
    $scope.$digest();

  _loadData = ->
    formData.getForm(formId)
      .success (data, status) ->
        formData.getFormUserResponse(resId)
          .success (results, status) ->
            _prepareData(data, results)

  _prepareData = (data, results) ->
    form = data
    for index, field of results[0].results
      section = _.find form.sections, (s) -> s._id is field.section_id
      secField = _.find section.fields, (s) -> s._id is field.field_id

      if field.field_type in ['text', 'textarea']
        secField.response = field.response
      else if field.field_type in ['radiobutton', 'select']
        choice = _.find secField.choices, (s) -> s._id is field.response
        secField.response = choice.label
      else if field.field_type is 'checkbox'
        response = []
        field.response.forEach (val) ->
          choice = _.find secField.choices, (s) -> s._id is val
          if choice
            response.push(choice.label)
        secField.response = response.join(', ')

    $scope.form = data



  $scope.init()
