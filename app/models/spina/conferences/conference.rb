# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conferences.
    class Conference < ApplicationRecord
      include ConferencePagePartable

      after_initialize :set_dates
      before_validation :update_dates

      attribute :start_date, :date
      attribute :finish_date, :date

      belongs_to :institution, inverse_of: :conferences
      has_many :room_possessions, dependent: :destroy
      has_many :rooms, through: :room_possessions
      has_many :presentation_types, dependent: :destroy
      has_many :presentations, through: :presentation_types
      has_and_belongs_to_many :delegates, foreign_key: :spina_conferences_conference_id,
                                          association_foreign_key: :spina_conferences_delegate_id

      delegate :name, to: :institution, prefix: true, allow_nil: true

      validates_associated :room_possessions
      validates_associated :presentation_types

      validates :start_date, :finish_date, :room_ids, :institution_id, presence: true
      validates :finish_date, finish_date: true, unless: proc { |conference| conference.start_date.blank? }

      scope :sorted, -> { order dates: :desc }

      # Returns the `:name` of the associated `:institution`, and year of the beginning of `:dates`, commonly used to
      # identify a conference.
      def name
        "#{institution_name} #{dates&.min&.year}"
      end

      def set_dates
        return unless dates

        self.start_date ||= dates.min
        self.finish_date ||= dates.max
      end

      def update_dates
        self.dates = start_date..finish_date if (start_date != dates&.min) || (finish_date != dates&.max)
      end
    end
  end
end
