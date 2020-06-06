# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents conferences.
      class Conference < ApplicationRecord
        translates :name, fallbacks: true

        scope :sorted, -> { order dates: :desc }

        has_many :presentation_types, inverse_of: :conference, dependent: :restrict_with_error
        has_many :sessions, through: :presentation_types
        has_many :presentations, through: :presentation_types
        has_many :rooms, through: :sessions
        has_many :institutions, through: :rooms
        has_and_belongs_to_many :delegates, foreign_key: :spina_conferences_conference_id,
                                            association_foreign_key: :spina_conferences_delegate_id

        validates_associated :presentation_types

        validates :name, :start_date, :finish_date, :year, presence: true
        validates :finish_date, 'spina/admin/conferences/finish_date': true, unless: proc { |conference| conference.start_date.blank? }

        def start_date
          return if dates.blank?

          dates.begin
        end

        def start_date=(date)
          self.dates = date.try(:to_date)..finish_date
        end

        def finish_date
          return if dates.blank?

          if dates.exclude_end?
            dates.end - 1.day if dates.end.is_a? Date
          else
            dates.end
          end
        end

        def finish_date=(date)
          self.dates = start_date..date.try(:to_date)
        end

        def year
          return if start_date.blank?

          start_date.try(:year)
        end

        def localized_dates
          return if dates.blank?

          dates.entries.collect { |date| { date: date.to_formatted_s(:iso8601), localization: I18n.l(date, format: :long) } }
        end

        def location
          institutions.collect(&:name).to_sentence
        end

        def to_ics
          event = Icalendar::Event.new
          return event if invalid?

          event.dtstart = start_date
          event.dtstart.ical_param(:value, 'DATE')
          event.dtend = finish_date
          event.dtend.ical_param(:value, 'DATE')
          event.location = location
          event.categories = Conference.model_name.human(count: 0)
          event.summary = name
          event
        end
      end
    end
  end
end
