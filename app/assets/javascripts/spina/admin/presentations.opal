# frozen_string_literal: true

Document.on :'turbolinks:load' do
  conference_id_element = Element.find('#presentation_spina_conference_id')
  conference_id_element.on :change do
    HTTP.get("/admin/conferences/#{conference_id_element.value}") do |response|
      presentation_date_element = Element.find('#presentation_date')
      presentation_date_element.children(nil).remove
      response.json.each do |date|
        element = Element.new :option
        element.text date[:label]
        element.attr :value, date[:date]
        presentation_date_element.append element
      end
    end
  end
end
