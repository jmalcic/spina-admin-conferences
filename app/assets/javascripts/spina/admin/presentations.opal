# frozen_string_literal: true

Document.on :'turbolinks:load' do
  conference_id_element = Element.find('#presentation_conference')
  conference_id_element.on :change do
    HTTP.get(
      "/admin/collect/conferences/#{conference_id_element.value}"
    ) do |response|
      replace_options(:presentation_date,
                      response,
                      :dates,
                      %i[label],
                      :date)
      replace_options(:presentation_presentation_type,
                      response,
                      :presentation_types,
                      %i[name])
    end
  end
  presentation_type_id_element = Element.find('#presentation_presentation_type')
  presentation_type_id_element.on :change do
    HTTP.get(
      "/admin/collect/presentation_types/#{presentation_type_id_element.value}"
    ) do |response|
      replace_options(:presentation_room_use_id,
                      response,
                      :room_uses,
                      %i[room_name])
    end
  end
end

def replace_options(element_id, response, model_attribute, text_keys,
                    value_key = :id)
  element = Element.find("##{element_id}")
  element.children(nil).remove
  options(response, model_attribute, text_keys, value_key).each do |option|
    element.append option
  end
end

def options(response, model_attribute, text_keys, value_key)
  options = []
  response.json[model_attribute].each do |item|
    option_element = Element.new :option
    text_values = text_keys.collect { |key| item[key] }
    option_element.text text_values.join(' ')
    option_element.attr :value, item[value_key]
    options << option_element
  end
  options
end
