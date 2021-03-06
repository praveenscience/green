'use strict'

angular.module 'greenApp'
.service 'formData', ($http) ->
  # AngularJS will instantiate a singleton by calling 'new' on this function
  update: (form) ->
    _form = angular.copy(form)
    if _form.certificates.length > 0
      certf = []
      form.certificates.forEach (val) ->
        certf.push(val._id)
      _form.certificates  = certf

    $http
      url: "api/forms/#{form._id}"
      method: 'PUT'
      data: _form

  getForm: (formId) ->
    $http
      method: "GET"
      url: "/api/forms/#{formId}"

  removeField: (fieldId) ->
    $http
      method: "DELETE"
      url: "/api/fields/#{fieldId}"

  getFormUserResponse: (resultsId) ->
    $http
      url: "api/results/#{resultsId}"
      method: 'GET'

  addField: (field) ->
    $http
      url: "api/fields"
      method: 'POST'
      data: field

  results: (formId) ->
    $http
      url: "api/results/#{formId}/all"
      method: 'GET'

  getCsv: (resId) ->
    $http
      url: "api/results/#{resId}/export"
      method: 'GET'

  respond: (responseForm) ->
    responses = []
    sections = []
    for sectionIndex, section of responseForm.sections
      sections.push
        id: section._id
        possible_points: section.possible_points,
        aquired_points: section.aquired_points

      for fieldIndex, field of section.fields
        response =
          section_id: section._id
          field_id: field._id
          field_type: field.type
          response: ""
          result_id: ""
          aquired_points: field.aquired_points or 0
          possible_points: field.possible_points or 0

        if field.choices.length isnt 0 and field.response is undefined
          if field.type is 'radiobutton'
            response.response = field.response if field.response
          else
            # Checkbox case - multiselect
            selections = []
            $.each field.choices, (index, choice) ->
              selections.push choice._id if choice.selected
            response.response = selections
        else
          response.response = field.response

        # Add to responses
        responses.push response

    submissionData =
      form: responseForm._id
      submitted: responseForm.submitted
      results: responses
      sections: sections
      points: responseForm.aquired_points
      total_points: responseForm.total_points
      results_id: responseForm.results_id if responseForm.results_id isnt undefined

    $http
      url: "api/results/#{responseForm._id}"
      method: 'PUT'
      data: submissionData
