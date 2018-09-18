# frozen_string_literal: true

module Spina
  module Collect
    # This class represents the use of a room for a kind of
    # presentation
    class RoomUse < ApplicationRecord
      belongs_to :room_possession, inverse_of: :room_uses
      belongs_to :presentation_type, inverse_of: :room_uses
      has_many :presentations, dependent: :nullify

      validates_inclusion_of(
        :room_possession,
        in: lambda do |room_use|
          room_use.presentation_type.conference.room_possessions
        end,
        message: 'does not belong to the associated conference'
      )
      validates_associated :room_possession

      def room_name
        room_possession.room.name
      end
    end
  end
end
