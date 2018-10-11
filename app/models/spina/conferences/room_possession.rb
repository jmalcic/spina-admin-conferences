# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents the possession of a room by a conference.
    class RoomPossession < ApplicationRecord
      belongs_to :room, inverse_of: :room_possessions
      belongs_to :conference, inverse_of: :room_possessions
      has_many :room_uses, dependent: :destroy
      has_many :presentation_types, through: :room_uses

      validates_inclusion_of(
        :room,
        in: lambda do |room_possession|
          room_possession.conference.institution.rooms
        end,
        message: 'does not belong to the associated institution'
      )

      def room_name
        room.name
      end
    end
  end
end
