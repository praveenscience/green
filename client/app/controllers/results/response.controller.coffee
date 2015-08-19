'use strict'

angular.module 'greenApp'
.controller 'ResponseCtrl', ($scope, $routeParams, formData, Utils, $timeout, $anchorScroll, $location) ->

  formId = $routeParams.id
  resId = $routeParams.res

  $scope.results = []
  $scope.form = null
  $scope.secitons = []
  $scope.possiblePoints = 0
  $scope.aquiredPoints = 0
  $scope.certificate = null
  $scope.colors = ["#1f77b4", "#aec7e8", "#ff7f0e", "#ffbb78", "#2ca02c", "#98df8a", "#d62728", "#ff9896", "#9467bd", "#c5b0d5", "#8c564b", "#c49c94", "#e377c2", "#f7b6d2", "#7f7f7f", "#c7c7c7", "#bcbd22", "#dbdb8d", "#17becf", "#9edae5"]

  $scope.getFormatedDate = Utils.getFormatedDate

  $scope.getBg = (index) ->
    background: $scope.colors[index]

  $scope.init = ->
    _loadData()

  $scope.getExportUrl = ->
    formData.getCsv(resId)
      .success((data) ->
        window.location.href = data
      )

  $scope.scrollToSeciton = (index, section) ->
    $timeout ->
      $('html, body').animate
        scrollTop: document.getElementById("seciton-#{index}").offsetTop + "px"
      100
    , 10

    $timeout ->
      $scope.form.sections.forEach (sec) -> sec.active = false
      section.active = true
      $scope.$digest();
    , 400

  _initWaypoints = ->
    $timeout ->
      sticky = new Waypoint.Sticky
        element: $('.fixed-navigation')[0]

      $('.response-section').each((i, el) ->
        new Waypoint
          element: el
          handler: (direction) -> _updateCurrent(this.element.id.split('-')[1])
          offset: 5
      )
    , 800

  _updateCurrent = (id) ->
    $scope.form.sections.forEach (sec) -> sec.active = false
    $scope.form.sections[id].active = true
    $scope.$digest();

  _loadData = ->
    formData.getForm(formId)
      .success (data, status) ->
        formData.getFormUserResponse(resId)
          .success (results, status) ->
            if results.length != 0
              $scope.results = results[0]
              $scope.certificate = results[0].certificate
              _prepareData(data, results)
              _generateGraph()
              _initWaypoints()
          .error (data, status) ->
              $timeout ->
                $location.path('/forms')
              , 100

  _generateGraph = ->
    for i, val of $scope.results.results
      if $scope.secitons[val.section_id] is undefined
        $scope.secitons[val.section_id] =
          possible_points: 0
          aquired_points: 0

      $scope.aquiredPoints += val.aquired_points
      $scope.possiblePoints += val.possible_points

      $scope.secitons[val.section_id].possible_points += val.possible_points
      $scope.secitons[val.section_id].aquired_points += val.aquired_points

    dataForGraph = []
    values = {}
    values = []
    l = 1
    for j, sec of $scope.secitons
      percentage = 0
      if sec.possible_points != 0
        percentage = (sec.aquired_points / sec.possible_points) * 100
      values.push({
        x: "Sec #{l}"
        y: percentage
      })
      l++


    dataForGraph = [
      {
        key: "Your points"
        values: values
      }
    ]

    _renderGraph(dataForGraph)

  _renderGraph = (data) ->
    nv.addGraph ->
      chart = nv.models
        .discreteBarChart()
        .x((d) -> d.x)
        .y((d) -> d.y)
        #.staggerLabels(true)
        .showValues(true)
        #.color(colors)

      #chart.yAxis.scale().domain([0, 100]);
      chart.forceY([0, 100])
      chart.yAxis
        .tickFormat((d) -> d3.format(',.f')(d) + "%");

      d3.select('#chart svg').datum(data).call chart

      nv.utils.windowResize chart.update

      chart



  _prepareData = (data, results) ->
    form = data
    for index, field of results[0].results
      section = _.find form.sections, (s) -> s._id is field.section_id
      secField = _.find section.fields, (s) -> s._id is field.field_id

      secField.possible_points = field.possible_points
      secField.aquired_points = field.aquired_points

      if field.field_type in ['text', 'textarea']
        secField.response = field.response
      else if field.field_type in ['radiobutton', 'select']
        choice = _.find secField.choices, (s) -> s._id is field.response
        secField.response = choice.label if choice
      else if field.field_type is 'checkbox' and field.response
        response = []
        field.response.forEach (val) ->
          choice = _.find secField.choices, (s) -> s._id is val
          if choice
            response.push(choice.label)
        secField.response = response.join(', ')

    form.user_info = results[0].user_info
    form.res_updated = results[0].updated
    $scope.form = data

  $scope.init()
