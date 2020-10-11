# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Events during conferences.
      #
      # = Validators
      # Presence:: {#name}, {#start_time}, {#finish_time}.
      # Conference date (using {ConferenceDateValidator}):: {#start_time}, {#finish_time}.
      # @see ConferenceDateValidator
      #
      # = Translations
      # - {#name}
      # - {#description}
      # - {#location}
      class Event < ApplicationRecord
        default_scope { includes(:translations) }

        # @!attribute [rw] name
        #   @return [String, nil] the translated name of the conference
        # @!attribute [rw] description
        #   @return [String, nil] the translated description of the conference
        # @!attribute [rw] location
        #   @return [String, nil] the translated location of the conference
        translates :name, :description, :location, fallbacks: true

        # @return [ActiveRecord::Relation] all events, ordered by name
        scope :sorted, -> { i18n.order :name }

        # @!attribute [rw] conference
        #   @return [Conference, nil] directly associated conferences
        belongs_to :conference, -> { includes(:translations) }, inverse_of: :events, touch: true

        validates :name, :date, :start_time, :start_datetime, :finish_time, :finish_datetime, :location, presence: true
        validates :date, 'spina/admin/conferences/conference_date': true
        validates :finish_time, 'spina/admin/conferences/finish_time': true

        # @return [Date, nil] the start date of the event. Nil if the event has no start date and time
        def date
          return if start_datetime.blank?

          start_datetime.to_date
        end

        # Sets the date of the presentation.
        # @param date [Date] the new date
        # @return [void]
        def date=(date)
          if date.blank? || date.to_date.blank?
            self.start_datetime = nil
            return
          end

          self.start_datetime = date.to_date + (start_datetime.try(:seconds_since_midnight) || 0).seconds
        end

        # @return [ActiveSupport::TimeWithZone, nil] the start time of the event. Nil if the event has no start date and time
        def start_time
          return if start_datetime.blank?

          start_datetime
        end

        # Sets the start time of the event.
        # @param start_time [ActiveSupport::TimeWithZone] the new start time
        # @return [void]
        def start_time=(start_time)
          if start_time.blank?
            self.start_datetime = nil
            return
          end

          self.start_datetime = Time.parse(start_time, date).to_datetime.in_time_zone
        end

        # @return [ActiveSupport::TimeWithZone, nil] the finish time of the event. Nil if the event has no finish date and time
        def finish_time
          return if finish_datetime.blank?

          finish_datetime
        end

        # Sets the finish time of the event.
        # @param finish_time [ActiveSupport::TimeWithZone] the new finish time
        # @return [void]
        def finish_time=(finish_time)
          if finish_time.blank?
            self.finish_datetime = nil
            return
          end

          self.finish_datetime = Time.parse(finish_time, date).to_datetime.in_time_zone
        end

        # @return [Icalendar::Event] the event as an iCal event
        def to_event # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          event = Icalendar::Event.new
          return event if invalid?

          event.dtstart = start_datetime
          event.dtend = finish_datetime
          event.location = location
          event.contact = Spina::Account.first.email
          event.categories = Event.model_name.human(count: 0)
          event.summary = name
          event.append_custom_property('alt_description', description.try(:html_safe))
          event.description = description.try(:gsub, %r{</?[^>]*>}, '')
          event
        end

        # @param (see #to_event)
        # @deprecated Use {#to_event} instead
        def to_ics
          to_event
        end
      end
    end
  end
end
