# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conferences.
    class Conference < ApplicationRecord
      after_initialize :set_from_dates
      before_validation :update_dates
      after_save :update_from_dates

      attribute :start_date, :date
      attribute :finish_date, :date
      attribute :year, :integer

      belongs_to :institution, inverse_of: :conferences
      has_many :room_possessions, inverse_of: :conference, dependent: :destroy
      has_many :rooms, through: :room_possessions
      has_many :presentation_types, inverse_of: :conference, dependent: :destroy
      has_many :presentations, through: :presentation_types
      has_and_belongs_to_many :delegates, foreign_key: :spina_conferences_conference_id,
                                          association_foreign_key: :spina_conferences_delegate_id

      delegate :name, to: :institution, prefix: true, allow_nil: true

      validates_associated :room_possessions, unless: proc { |conference| conference.institution.blank? }
      validates_associated :presentation_types

      validates :start_date, :finish_date, :rooms, :institution, presence: true
      validates :finish_date, 'spina/conferences/finish_date': true, unless: proc { |conference| conference.start_date.blank? }

      scope :sorted, -> { order dates: :desc }

      def self.import(file)
        ConferenceImportJob.perform_later IO.read(file)
      end

      def self.description
        nil
      end

      def self.seo_title
        'Conferences'
      end

      class << self
        alias menu_title seo_title
      end

      # Returns the `:name` of the associated `:institution`, and year of the beginning of `:dates`, commonly used to
      # identify a conference.
      def name
        "#{institution_name} #{year}"
      end

      # rubocop:disable Metrics/AbcSize

      def to_ics
        event = Icalendar::Event.new
        return event if invalid?

        event.dtstart = start_date
        event.dtstart.ical_param(:value, 'DATE')
        event.dtend = finish_date
        event.dtend.ical_param(:value, 'DATE')
        event.location = institution.name
        event.categories = self.class.name.demodulize.upcase
        event.summary = name
        event
      end

      # rubocop:enable Metrics/AbcSize

      def set_from_dates
        return if dates.blank?

        self.start_date ||= dates.min
        self.finish_date ||= dates.max
        self.year ||= start_date.year
        clear_attribute_changes %i[start_date finish_date year]
      end

      def update_from_dates
        return if dates.blank?

        self.start_date = dates.min
        self.finish_date = dates.max
        self.year = start_date.year
        clear_attribute_changes %i[start_date finish_date year]
      end

      def update_dates
        return unless changed_attributes.keys.inquiry.any?(:start_date, :finish_date)

        self.dates = start_date..finish_date
      end

      def description
        content('text') || nil
      end

      alias seo_title name

      def ancestors
        nil
      end

      alias menu_title name

      def materialized_path
        ::Spina::Engine.routes.url_helpers.conferences_conference_path self
      end

      def localized_dates
        dates.entries.collect { |date| { date: date.iso8601, localization: I18n.localize(date, format: :long) } }
      end
    end
  end
end
