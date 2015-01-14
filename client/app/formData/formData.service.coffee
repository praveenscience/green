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

  removeField: (fieldId) ->
    $http
      method: "DELETE"
      url: "/api/fields/#{fieldId}"

  getFormUserResponse: (formId) ->
    $http
      url: "api/results/#{formId}"
      method: 'GET'

  addField: (field) ->
    $http
      url: "api/fields"
      method: 'POST'
      data: field

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
      form_id: responseForm._id
      submitted: responseForm.submitted
      results: responses

    $http
      url: "api/results/#{responseForm._id}"
      method: 'PUT'
      data: submissionData
