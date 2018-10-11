# frozen_string_literal: true

xml.presentationtypes do
  @presentation_types&.each do |presentation_type|
    xml.presentationtype(
      presentation_type.name,
      id: "presentation_type_#{presentation_type.id}",
      duration: presentation_type.duration.iso8601
    )
  end
end
