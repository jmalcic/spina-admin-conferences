# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Conference records.
      #
      # = Validators
      # Presence:: {#name}, {#start_date}, {#finish_date}, {#year}.
      # Conference date (using {FinishDateValidator}):: {#finish_date}.
      # @see FinishDateValidator
      #
      # = Translations
      # - {#name}
      class Conference < ApplicationRecord
        include AttrJson::Record
        include AttrJson::NestedAttributes
        include Spina::Partable
        include Spina::TranslatedContent

        default_scope { includes(:translations) }

        # @!attribute [rw] dates
        #   @return [Range<Date>, nil] the dates of the conference

        # @!attribute [rw] name
        #   @return [String, nil] the translated name of the conference
        translates :name, fallbacks: true

        # @return [ActiveRecord::Relation] all conferences, ordered by date
        scope :sorted, -> { order dates: :desc }

        # @!attribute [rw] presentation_types
        #   @return [ActiveRecord::Relation] directly associated presentation types
        #   @note A conference cannot be destroyed if it has dependent presentation types.
        #   @see PresentationType
        has_many :presentation_types, -> { includes(:translations) }, inverse_of: :conference, dependent: :restrict_with_error
        # @!attribute [rw] events
        #   @return [ActiveRecord::Relation] directly associated events
        #   @note Destroying a conference destroys dependent events.
        #   @see Event
        has_many :events, -> { includes(:translations) }, inverse_of: :conference, dependent: :destroy
        # @!attribute [rw] sessions
        #   @return [ActiveRecord::Relation] Sessions associated with {#presentation_types}
        #   @see Session
        #   @see PresentationType#sessions
        has_many :sessions, -> { distinct.includes(:translations) }, through: :presentation_types
        # @!attribute [rw] presentations
        #   @return [ActiveRecord::Relation] Presentations associated with {#sessions}
        #   @see Presentation
        #   @see Session#presentations
        has_many :presentations, -> { distinct.includes(:translations) }, through: :sessions
        # @!attribute [rw] rooms
        #   @return [ActiveRecord::Relation] Rooms associated with {#sessions}
        #   @see Room
        #   @see Session#rooms
        has_many :rooms, -> { distinct.includes(:translations) }, through: :sessions
        # @!attribute [rw] institutions
        #   @return [ActiveRecord::Relation] Institutions associated with {#rooms}
        #   @see Institution
        #   @see Room#institutions
        has_many :institutions, -> { distinct.includes(:translations) }, through: :rooms
        # @!attribute [rw] delegates
        #   @return [ActiveRecord::Relation] directly associated delegates
        #   @see Delegate
        has_and_belongs_to_many :delegates, foreign_key: :spina_conferences_conference_id, # rubocop:disable Rails/HasAndBelongsToMany
                                            association_foreign_key: :spina_conferences_delegate_id
        accepts_nested_attributes_for :events, allow_destroy: true

        validates :name, :start_date, :finish_date, :year, presence: true
        validates :finish_date, 'spina/admin/conferences/finish_date': true, unless: proc { |conference| conference.start_date.blank? }

        # @return [Array<TZInfo::TimezonePeriod>] the time zone periods for the conferences
        def self.time_zone_periods
          pluck(:dates).compact.collect(&:begin).collect(&:at_beginning_of_day).collect(&:period)
        end

        # @return [String] a set of conferences as an iCalendar
        def self.to_ics
          Rails.cache.fetch [all, 'calendar'] do
            calendar = Icalendar::Calendar.new
            calendar.x_wr_calname = (Current.account || Spina::Account.first).name
            calendar.add_timezone(ical_timezone)
            all.in_batches.each_record do |conference|
              Rails.cache.fetch([conference, 'event']) { conference.to_event }
                         .then { |event| calendar.add_event(event) }
            end
            calendar.publish
            calendar.to_ical
          end
        end

        # @return [Date, nil] the start date of the conference. Nil if the conference has no dates
        def start_date
          return if dates.blank?

          dates.begin
        end

        # Sets the start date of the conference.
        # @param date [Date] the new start date
        # @return [void]
        def start_date=(date)
          self.dates = date.try(:to_date)..finish_date
        end

        # @return [Date, nil] the finish date of the conference. Nil if the conference has no dates
        def finish_date
          return if dates.blank?

          if dates.exclude_end?
            dates.end - 1.day if dates.end.is_a? Date
          else
            dates.end
          end
        end

        # Sets the finish date of the conference.
        # @param date [Date] the new finish date
        # @return [void]
        def finish_date=(date)
          self.dates = start_date..date.try(:to_date)
        end

        # @return [Integer, nil] the year of the conference. Nil if the conference has no dates
        def year
          return if start_date.blank?

          start_date.try(:year)
        end

        # @return [Array<Hash{Symbol=>String}>, nil] an array of hashes containing the date in ISO 8601 format and as a localised string
        #   Nil if the conference has no dates.
        def localized_dates
          return if dates.blank?

          dates.entries.collect { |date| { date: date.to_formatted_s(:iso8601), localization: I18n.l(date, format: :long) } }
        end

        # @return [String] the names of each institution associated with the conference
        def location
          institutions.collect(&:name).to_sentence
        end

        # @return [Icalendar::Event] the conference as an iCal event
        def to_event # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          event = Icalendar::Event.new
          return event if invalid?

          event.dtstart = Icalendar::Values::Date.new(dates.begin)
          event.dtend = Icalendar::Values::Date.new(dates.exclude_end? ? dates.end : dates.end + 1.day)
          event.location = location
          event.contact = Spina::Account.first.email
          event.categories = Conference.model_name.human(count: 0)
          event.summary = name
          event
        end

        # @return [TZInfo::TimezonePeriod, nil] the time zone period for the conference event
        def time_zone_period
          return if start_date.blank?

          start_date.at_beginning_of_day.period
        end

        # @return [String, nil] the conference as an iCalendar
        def to_ics
          Rails.cache.fetch [self, presentations, 'calendar'] do
            calendar = Icalendar::Calendar.new
            return if invalid?

            calendar.x_wr_calname = name
            calendar.add_timezone(ical_timezone)
            eventables.each do |eventable|
              Rails.cache.fetch([eventable, 'event']) { eventable.to_event }
                         .then { |event| calendar.add_event(event) }
            end
            calendar.publish
            calendar.to_ical
          end
        end

        private

        def self.ical_timezone
          Rails.cache.fetch [self, 'time_zone'] do
            Icalendar::Timezone.new do |timezone|
              timezone.tzid = Time.zone.name
              time_zone_periods.each do |period|
                timezone.send(period.dst? ? :daylight : :standard) do |daylight|
                  daylight.tzoffsetfrom = period.offset.ical_offset
                  daylight.tzoffsetto = period.offset.ical_offset
                  daylight.tzname = period.abbreviation
                  daylight.dtstart = period.start_transition.at.utc.to_datetime
                end
              end
            end
          end
        end

        def eventables
          [self, *events, *presentations]
        end

        def ical_timezone
          Rails.cache.fetch [self, presentations, 'time_zone'] do
            Icalendar::Timezone.new do |timezone|
              timezone.tzid = Time.zone.name
              eventables.collect(&:time_zone_period).uniq.each do |period|
                timezone.send(period.dst? ? :daylight : :standard) do |daylight|
                  daylight.tzoffsetfrom = period.offset.ical_offset
                  daylight.tzoffsetto = period.offset.ical_offset
                  daylight.tzname = period.abbreviation
                  daylight.dtstart = period.start_transition.at.utc.to_datetime
                end
              end
            end
          end
        end
      end
    end
  end
end
