'use strict'

angular.module 'greenApp'
.controller 'FormshowSuccessCtrl', ($scope, $timeout, $http, $routeParams, formData, Auth, $location) ->

  $scope.form = {}
  $scope.results = null
  formId = $routeParams.id
  resultId = $routeParams.res
  $scope.certificate = null

  $scope.totalPoints = 0
  $scope.aquiredPoints = 0
  $scope.isAdmin = Auth.isAdmin

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
