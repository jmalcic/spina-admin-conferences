# frozen_string_literal: true

Document.on 'turbolinks:load' do
  get_on_change(:conference_id, :conferences) do |conferences_response|
    replace_options(conferences_response,
                    :presentation_type_id,
                    :presentation_types,
                    :name,
                    :id)
    replace_options(conferences_response,
                    :presentation_date,
                    :dates,
                    :label,
                    :date)
    get_json(:presentation_type_id,
             :presentation_types) do |presentation_types_response|
      replace_options(
        presentation_types_response,
        :presentation_room_use_id,
        :room_uses,
        :room_name
      )
    end
  end
  get_on_change(:presentation_type_id, :presentation_types) do |response|
    replace_options(response,
                    :presentation_room_use_id,
                    :room_uses,
                    :room_name)
  end
end

def get_on_change(attribute, controller)
  Element["##{attribute}"].on :change do
    get_json(attribute, controller) { |response| yield(response) }
  end
end

def get_json(attribute, controller)
  HTTP.get(
    "/admin/collect/#{controller}/#{Element["##{attribute}"].value}"
  ) { |response| yield(response) }
end

def replace_options(response, element_id, collection, text_key,
                    value_key = :id)
  Element["##{element_id}"].children(nil).remove
  options_for_select(response.json[collection], text_key,
                     value_key).each do |option|
    Element["##{element_id}"].append option
  end
end

def options_for_select(collection, text_key, value_key)
  options = []
  collection.each do |item|
    option_element = Element.new :option
    option_element.text item[text_key]
    option_element.attr :value, item[value_key]
    options << option_element
  end
  options
end
