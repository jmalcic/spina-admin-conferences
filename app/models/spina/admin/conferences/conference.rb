# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents conferences.
      class Conference < ApplicationRecord
        translates :name, fallbacks: true

        scope :sorted, -> { order dates: :desc }

        after_initialize :set_from_dates
        before_validation :update_dates
        after_save :update_from_dates

        attribute :start_date, :date
        attribute :finish_date, :date
        attribute :year, :integer

        has_many :presentation_types, inverse_of: :conference, dependent: :destroy
        has_many :sessions, through: :presentation_types
        has_many :presentations, through: :presentation_types
        has_many :rooms, through: :sessions
        has_many :institutions, through: :rooms
        has_and_belongs_to_many :delegates, foreign_key: :spina_conferences_conference_id,
                                            association_foreign_key: :spina_conferences_delegate_id

        validates_associated :presentation_types

        validates :start_date, :finish_date, :name, presence: true
        validates :finish_date, 'spina/admin/conferences/finish_date': true, unless: proc { |conference| conference.start_date.blank? }


        def self.description
          nil
        end

        def self.seo_title
          'Conferences'
        end

        class << self
          alias menu_title seo_title
        end

        def location
          institutions.collect(&:name).to_sentence
        end

        # rubocop:disable Metrics/AbcSize

        def to_ics
          event = Icalendar::Event.new
          return event if invalid?

          event.dtstart = start_date
          event.dtstart.ical_param(:value, 'DATE')
          event.dtend = finish_date
          event.dtend.ical_param(:value, 'DATE')
          event.location = location
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
end
