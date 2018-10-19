# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents rooms in an institution.
    class Room < ApplicationRecord
      belongs_to :institution, inverse_of: :rooms, autosave: true
      has_many :room_possessions, dependent: :destroy
      has_many :room_uses, through: :room_possessions
      has_many :presentations, through: :room_uses

      validates_presence_of :number, :building

      scope :sorted, -> { order :building, :number }

      def building_and_number
        "#{building} #{number}"
      end

      alias_method :name, :building_and_number
    end
  end
end
