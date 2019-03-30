# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents presentation types (e.g. plenaries, poster presentations, etc.)
    class PresentationType < ApplicationRecord
      after_initialize :set_from_duration
      before_validation :set_duration

      attribute :duration, :interval
      attribute :minutes, :integer

      belongs_to :conference, inverse_of: :presentation_types
      has_many :room_uses, dependent: :destroy
      has_many :room_possessions, through: :room_uses
      has_many :rooms, through: :room_possessions
      has_many :presentations, through: :room_uses

      validates :name, :minutes, :room_uses, presence: true
      validates :minutes, numericality: { greater_than_or_equal_to: 1 }
      validates_associated :room_uses

      scope :sorted, -> { order :name }

      def set_from_duration
        self.minutes ||= duration / ActiveSupport::Duration::SECONDS_PER_MINUTE if duration
      end

      def set_duration
        self.duration = minutes.minutes if minutes
      end
    end
  end
end
