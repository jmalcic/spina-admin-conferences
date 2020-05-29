# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents rooms in an institution.
      class Room < ApplicationRecord
        belongs_to :institution, inverse_of: :rooms, autosave: true
        has_many :room_possessions, inverse_of: :room, dependent: :destroy
        has_many :room_uses, through: :room_possessions
        has_many :presentations, through: :room_uses

        validates :number, :building, presence: true

        scope :sorted, -> { order :building, :number }

        def self.import(file)
          RoomImportJob.perform_later IO.read(file)
        end

        def name
          "#{building} #{number}"
        end
      end
    end
  end
end
