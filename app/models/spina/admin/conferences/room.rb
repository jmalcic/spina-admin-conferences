# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents rooms in an institution.
      class Room < ApplicationRecord
        translates :building, :number, fallbacks: true

        scope :sorted, -> { i18n.order :building, :number }

        belongs_to :institution, inverse_of: :rooms, autosave: true
        has_many :sessions, inverse_of: :room, dependent: :destroy
        has_many :presentations, through: :sessions

        validates :number, :building, presence: true

        def name
          return if building.blank? || number.blank?

          "#{building} #{number}"
        end
      end
    end
  end
end
