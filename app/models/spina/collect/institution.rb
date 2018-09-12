# frozen_string_literal: true

module Spina
  module Collect
    # This class represents institutions where a conference takes place.
    # An `Institution` has many `:conferences`, `:delegates`, and `:rooms`,
    # Destroying an `Institution` destroys associates `:rooms`.
    class Institution < ApplicationRecord
      has_many :conferences
      has_many :delegates
      has_many :rooms, dependent: :destroy

      validates_presence_of :name, :city
    end
  end
end
