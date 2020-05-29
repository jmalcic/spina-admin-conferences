# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents the use of a room for a kind of presentation
    class RoomUse < ApplicationRecord
      belongs_to :room_possession, inverse_of: :room_uses
      belongs_to :presentation_type, inverse_of: :room_uses, touch: true
      has_many :presentations, inverse_of: :room_use, dependent: :destroy
      has_one :conference, through: :presentation_type
      has_one :room, through: :room_possession
      has_one :institution, through: :conference

      validates :room_possession, inclusion: { in: ->(room_use) { room_use.conference.room_possessions },
                                               message: :does_not_belong_to_associated_conference,
                                               unless: proc { |room_use| room_use.conference.blank? } }
      validates_associated :room_possession

      delegate :name, to: :room, prefix: true
    end
  end
end
