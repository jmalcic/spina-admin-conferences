# frozen_string_literal: true

xml.rooms do
  @rooms&.each do |room|
    xml.room id: "room_#{room.id}", name: room.name do
      xml.institution room.institution.name
      xml.building room.building
      xml.number room.number
    end
  end
end
