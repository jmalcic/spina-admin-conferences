# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents the possession of a room by a conference.
    class RoomPossession < ApplicationRecord
      belongs_to :room, inverse_of: :room_possessions
      belongs_to :conference, inverse_of: :room_possessions
      has_many :room_uses, inverse_of: :room_possession, dependent: :destroy
      has_many :presentation_types, through: :room_uses
      has_one :institution, through: :conference

      validates :room, inclusion: { in: ->(room_possession) { room_possession.conference.institution.rooms },
                                    message: :does_not_belong_to_associated_institution },
                       unless: proc { |room_possession| room_possession.conference.blank? }

      delegate :name, to: :room, prefix: true
    end
  end
end
