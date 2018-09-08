# frozen_string_literal: true

Document.on :'turbolinks:load' do
  conference_id_element = Element.find('#presentation_conference_id')
  conference_id_element.on :change do
    HTTP.get("/admin/collect/conferences/#{conference_id_element.value}") do |response|
      date_element = Element.find('#presentation_date')
      room_id_element = Element.find('#presentation_room_id')
      presentation_type_id_element = Element.find('#presentation_presentation_type_id')
      date_element.children(nil).remove
      room_id_element.children(nil).remove
      presentation_type_id_element.children(nil).remove
      date_options(response.json[:dates]).each { |element| date_element.append element}
      room_options(response.json[:rooms]).each { |element| room_id_element.append element}
      presentation_type_options(response.json[:presentation_types]).each { |element| presentation_type_id_element.append element}
    end
  end
end

def date_options(dates)
  date_options = Array.new
  dates.each do |date|
    element = Element.new :option
    element.text date[:label]
    element.attr :value, date[:date]
    date_options << element
  end
  return date_options
end

def room_options(rooms)
  room_options = Array.new
  rooms.each do |room|
    element = Element.new :option
    element.text "#{room[:building]} #{room[:number]}"
    element.attr :value, room[:id]
    room_options << element
  end
  return room_options
end

def presentation_type_options(presentation_types)
  presentation_type_options = Array.new
  presentation_types.each do |presentation_type|
    element = Element.new :option
    element.text presentation_type[:name]
    element.attr :value, presentation_type[:id]
    presentation_type_options << element
  end
  return presentation_type_options
end
