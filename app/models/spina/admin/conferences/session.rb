# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents a session
      class Session < ApplicationRecord
        translates :name, fallbacks: true

        belongs_to :room, inverse_of: :sessions
        belongs_to :presentation_type, inverse_of: :sessions
        has_one :conference, through: :presentation_type
        has_one :institution, through: :room
        has_many :presentations, inverse_of: :session, dependent: :restrict_with_error

        validates :name, presence: true

        delegate :name, to: :room, prefix: true, allow_nil: true
        delegate :name, to: :presentation_type, prefix: true, allow_nil: true
      end
    end
  end
end
