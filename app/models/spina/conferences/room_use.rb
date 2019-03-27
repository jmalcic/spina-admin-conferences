# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents the use of a room for a kind of
    # presentation
    class RoomUse < ApplicationRecord
      belongs_to :room_possession, inverse_of: :room_uses
      belongs_to :presentation_type, inverse_of: :room_uses, touch: true
      has_many :presentations, dependent: :nullify

      validates :room_possession, inclusion: { in: ->(room_use) { room_use.conference.room_possessions },
                                               message: 'does not belong to the associated conference',
                                               unless: proc { |a| a.conference.blank? } }
      validates_associated :room_possession

      def room_name
        room_possession.room.name
      end
    end
  end
end
