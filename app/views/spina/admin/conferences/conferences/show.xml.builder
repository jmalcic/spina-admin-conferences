# frozen_string_literal: true

xml.conference id: "conference_#{@conference.id}" do
  xml.h1 @conference.name
  xml.dates do
    @conference.dates.each do |date|
      xml.time l(date, format: :short), datetime: date.iso8601
    end
  end
  xml.address "#{@conference.institution.name}, #{@conference.institution.city}"
  xml.rooms do
    @conference&.room_possessions&.each do |room_possession|
      xml.room room_possession.room_name, id: room_possession.id
    end
  end
  xml.presentationtypes do
    @conference&.presentation_types&.each do |presentation_type|
      xml.h2 presentation_type.name.pluralize, id: "presentation_type_#{presentation_type.id}"
      presentation_type.presentations.each do |presentation|
        xml.article do
          xml.h3 presentation.title
          xml.presenters do
            presentation.presenters.each do |presenter|
              xml.address"#{presenter.full_name}, #{presenter.institution.name}"
            end
          end
          xml.abstract presentation.abstract.try(:html_safe)
        end
      end
    end
  end
end
