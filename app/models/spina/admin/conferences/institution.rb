# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents institutions where a conference takes place.
      class Institution < ApplicationRecord
        translates :name, :city, fallbacks: true

        scope :sorted, -> { order :name }

        belongs_to :logo, class_name: 'Spina::Image', optional: true

        has_many :rooms, inverse_of: :institution, dependent: :destroy
        has_many :sessions, through: :rooms
        has_many :conferences, through: :sessions, autosave: true
        has_many :delegates, inverse_of: :institution, dependent: :destroy

        accepts_nested_attributes_for :rooms

        validates :name, :city, presence: true
      end
    end
  end
end
