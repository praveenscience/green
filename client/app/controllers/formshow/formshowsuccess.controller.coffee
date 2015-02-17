'use strict'

angular.module 'greenApp'
.controller 'FormshowSuccessCtrl', ($scope, $timeout, $http, $routeParams, formData, Auth, $location) ->

  $scope.form = {}
  $scope.results = null
  formId = $routeParams.id
  resultId = $routeParams.res
  $scope.certificate = null

  $scope.possiblePoints = 0
  $scope.aquiredPoints = 0
  $scope.isAdmin = Auth.isAdmin
  $scope.secitons = []

  $scope.formattedDate = ->
    date = new Date()
    return date.toUTCString().substr(5, 11)

  $scope.init = ->
    _loadFormData()

  _loadFormData = ->
    formData.getForm(formId)
      .success (data, status) ->
        formData.getFormUserResponse(resultId)
          .success (results, resultsStatus) ->
            $scope.results = results[0]
            $scope.form = data
            $scope.certificate = results[0].certificate
            # _generatePDF()
            _generateGraph()

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
        x: "Seciton#{l}"
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
        .showValues(true)

      #chart.yAxis.scale().domain([0, 100]);
      chart.forceY([0, 100])

      d3.select('#chart svg').datum(data).call chart

      nv.utils.windowResize chart.update

      chart




  _generatePDF = ->
    $timeout ->
      doc = new jsPDF('l')
      elementHandler = '#certificate': (element, renderer) ->
        true
      # doc.setFont("Source Sans Pro");
      source = document.getElementById('certificate')
      doc.fromHTML source, 15, 15,
        'elementHandlers': elementHandler

      string = doc.output('datauristring');
      $('.preview-pane').attr('src', string)

    , 1000

  $scope.init()
