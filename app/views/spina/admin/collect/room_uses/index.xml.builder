# frozen_string_literal: true

xml.roomuses do
  @room_uses&.each do |room_use|
    xml.roomuse id: "room_use_#{room_use.id}" do
      xml.presentationtype room_use.presentation_type.name
      xml.room room_use.room_name
    end
  end
end
