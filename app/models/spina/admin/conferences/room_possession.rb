# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents the possession of a room by a conference.
      class RoomPossession < ApplicationRecord
        belongs_to :room, inverse_of: :room_possessions
        belongs_to :conference, inverse_of: :room_possessions
        has_many :room_uses, inverse_of: :room_possession, dependent: :destroy
        has_many :presentation_types, through: :room_uses

        delegate :name, to: :room, prefix: true
      end
    end
  end
end
