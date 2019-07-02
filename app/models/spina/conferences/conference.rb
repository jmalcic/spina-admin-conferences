# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conferences.
    class Conference < ApplicationRecord
      include ConferencePagePartable
      include ::Spina::Partable

      after_initialize :set_from_dates
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
      has_many :parts, dependent: :destroy, as: :pageable
      accepts_nested_attributes_for :parts, allow_destroy: true

      delegate :name, to: :institution, prefix: true, allow_nil: true

      validates_associated :room_possessions
      validates_associated :presentation_types

      validates :start_date, :finish_date, :rooms, :institution, presence: true
      validates :finish_date, finish_date: true, unless: proc { |conference| conference.start_date.blank? }

      scope :sorted, -> { order dates: :desc }

      def self.import(file)
        ConferenceImportJob.perform_later IO.read(file)
      end

      # Returns the `:name` of the associated `:institution`, and year of the beginning of `:dates`, commonly used to
      # identify a conference.
      def name
        "#{institution_name} #{dates&.min&.year}"
      end

      def to_ics
        event = Icalendar::Event.new
        event.dtstart = start_date
        event.dtstart.ical_params = { value: 'DATE' }
        event.dtend = finish_date
        event.dtend.ical_params = { value: 'DATE' }
        event.location = institution.name
        event.categories = self.class.name.demodulize.upcase
        event.summary = name
        event
      end

      def set_from_dates
        return if dates.blank?

        self.start_date ||= dates.min
        self.finish_date ||= dates.max
      end

      def update_dates
        self.dates = start_date..finish_date if (start_date != dates&.min) || (finish_date != dates&.max)
      end

      def model_config(conferences_theme)
        conferences_theme.models[self.class.name.to_sym]
      end

      def model_parts(theme)
        conferences_theme = Conferences::THEMES.find { |conference_theme| conference_theme.name == theme.name }
        theme.parts.select { |page_part| page_part[:name].in? model_config(conferences_theme)[:parts] }
      end
    end
  end
end
