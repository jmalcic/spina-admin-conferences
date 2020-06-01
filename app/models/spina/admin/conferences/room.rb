# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents rooms in an institution.
      class Room < ApplicationRecord
        translates :building, :number, fallbacks: true

        belongs_to :institution, inverse_of: :rooms, autosave: true
        has_many :sessions, inverse_of: :room, dependent: :destroy
        has_many :presentations, through: :sessions

        validates :number, :building, presence: true

        scope :sorted, -> { i18n.order :building, :number }

        def name
          "#{building} #{number}"
        end
      end
    end
  end
end
