# frozen_string_literal: true

module Spina
  module Collect
    # This class represents institutions where a conference takes place.
    # An `Institution` has many `:conferences`, `:delegates`, and `:rooms`, and
    # also a `:logo`.
    # Destroying an `Institution` destroys associates `:rooms` and the `:logo`.
    class Institution < ApplicationRecord
      belongs_to :logo, class_name: 'Spina::Image', optional: true

      has_many :conferences
      has_many :delegates
      has_many :rooms, dependent: :destroy
      has_many :room_posessions, through: :rooms
      has_many :delegates, dependent: :destroy

      validates_presence_of :name, :city
    end
  end
end
