'use strict'

angular.module 'greenApp'
.service 'formData', ($http) ->
  # AngularJS will instantiate a singleton by calling 'new' on this function
  update: (form) ->
    $http
      url: "api/forms/#{form._id}"
      method: 'PUT'
      data: form

  getForm: (formId) ->
    $http
      method: "GET"
      url: "/api/forms/#{formId}"

  getFormUserResponse: (formId) ->
    $http
      url: "api/results/#{formId}"
      method: 'GET'

  respond: (responseForm) ->
    responses = []
    for sectionIndex, section of responseForm.sections
      for fieldIndex, field of section.fields
        response =
          section_id: section._id
          field_id: field._id
          field_type: field.type
          response: ""
          result_id: ""

        if field.choices.length isnt 0 and field.response is undefined
          if field.type in ['radio', 'select']
            $.each field.choices, (index, choice) ->
              response.response = choice._id if choice.selected
          else
            # Checkbox case - multiselect
            selections = []
            $.each field.choices, (index, choice) ->
              selections.push choice._id if choice.selected
            response.response = selections
        else
          response.response = if typeof field.response is "object"
            # Is a date
            $filter('date')(field.response, "fullDate")
          else
            # Normal case
            field.response

        # Add to responses
        responses.push response

    submissionData =
      form_id: responseForm._id
      submitted: responseForm.submitted
      results: responses

    $http
      url: "api/results/#{responseForm._id}"
      method: 'PUT'
      data: submissionData
