'use strict'

angular.module 'greenApp'
.controller 'FormshowSuccessCtrl', ($scope, $timeout, $http, $routeParams, formData, Auth, $location, SweetAlert) ->

  $scope.form = {}
  $scope.results = null
  formId = $routeParams.id
  resultId = $routeParams.res
  $scope.certificate = null

  $scope.possiblePoints = 0
  $scope.aquiredPoints = 0
  $scope.isAdmin = Auth.isAdmin
  $scope.secitons = []
  $scope.lab_name = null

  $scope.formattedDate = ->
    date = new Date()
    return date.toUTCString().substr(5, 11)

  $scope.init = ->
    _loadFormData()


  _showAlert = ->
    SweetAlert.swal {
      title: 'Certificate name '
      text: 'Enter the name of the organization that should be printed on your certificate:'
      type: 'input'
      showCancelButton: true
      closeOnConfirm: false
      animation: 'slide-from-top'
    }, (inputValue) ->
      if inputValue == false
        return false
      if inputValue == ''
        swal.showInputError 'You need to write something!'
        return false
      swal 'Nice!', "You wrote: #{inputValue}, click ok to generate your certificate", 'success'
      $scope.lab_name = inputValue
      return

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
            _showAlert() if $scope.certificate

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
    l = 0
    for j, sec of $scope.secitons
      percentage = 0
      if sec.possible_points != 0
        percentage = (sec.aquired_points / sec.possible_points) * 100
      values.push({
        x: $scope.form.sections[l].title #"Sec #{l}"
        y: percentage
        aquired_points: sec.aquired_points
        possible_points: sec.possible_points
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
        .staggerLabels(true)
        .showValues(true)
        .tooltipContent( (key, x, y, e, graph) ->
          console.log e
          """<h3>#{x}</h3>
            <div class='tooltip-cont'>
              <p><strong>#{e.point.aquired_points}</strong><small  class='text-muted'> out of</small> <strong class='text-muted'>#{e.point.possible_points} </strong> <small class='text-muted'> points</small> – <strong>#{parseFloat(y).toFixed(2)}% </strong></p>
            </div>
          """
        )
        #.color(colors)

      #chart.yAxis.scale().domain([0, 100]);
      chart.forceY([0, 100])
      chart.yAxis
        .tickFormat((d) -> d3.format(',.f')(d) + "%");

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
