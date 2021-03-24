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

          event.dtstart = start_date
          event.dtstart.ical_param(:value, 'DATE')
          event.dtend = finish_date
          event.dtend.ical_param(:value, 'DATE')
          event.location = location
          event.contact = Spina::Account.first.email
          event.categories = Conference.model_name.human(count: 0)
          event.summary = name
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
