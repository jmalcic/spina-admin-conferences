# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Events during conferences.
      #
      # = Validators
      # Presence:: {#name}, {#:start_datetime}, {#:finish_datetime}, {#:location}.
      # Conference date (using {ConferenceDateValidator}):: {#start_datetime}, {#finish_datetime}.
      # @see ConferenceDateValidator
      #
      # = Translations
      # - {#name}
      # - {#description}
      # - {#location}
      class Event < ApplicationRecord
        default_scope { includes(:translations) }

        # @!attribute [rw] name
        #   @return [String, nil] the translated name of the event
        # @!attribute [rw] description
        #   @return [String, nil] the translated description of the event
        # @!attribute [rw] start_datetime
        #   @return [ActiveSupport::TimeWithZone, nil] the start time of the event
        # @!attribute [rw] finish_datetime
        #   @return [ActiveSupport::TimeWithZone, nil] the finish time of the event
        # @!attribute [rw] location
        #   @return [String, nil] the translated location of the event
        translates :name, :description, :location, fallbacks: true

        # @return [ActiveRecord::Relation] all events, ordered by name
        scope :sorted, -> { i18n.order :name }

        # @!attribute [rw] start_time
        #   @return [ActiveSupport::TimeWithZone, nil] the start time (alias)
        #   @see #start_datetime
        alias_attribute :start_time, :start_datetime
        # @!attribute [rw] :finish_time
        #   @return [ActiveSupport::TimeWithZone, nil] the finish time (alias)
        #   @see #finish_datetime
        alias_attribute :finish_time, :finish_datetime

        # @!attribute [rw] conference
        #   @return [Conference, nil] directly associated conferences
        belongs_to :conference, -> { includes(:translations) }, inverse_of: :events, touch: true

        validates :name, :start_datetime, :finish_datetime, :location, presence: true
        validates :start_datetime, :finish_datetime, 'spina/admin/conferences/conference_date': true
        validates :finish_datetime, 'spina/admin/conferences/finish_time': true

        # @return [Date, nil] the start date of the event. Nil if the event has no start date and time
        def date
          return if start_datetime.blank?

          start_datetime.to_date
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
      end
    end
  end
end
