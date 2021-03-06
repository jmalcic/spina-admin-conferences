# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Presentation records.
      #
      # = Validators
      # Presence:: {#title}, {#date}, {#start_time}, {#start_datetime}, {#abstract}, {#presenters}.
      # Conference date (using {ConferenceDateValidator}):: {#date}.
      # @see ConferenceDateValidator
      #
      # = Translations
      # - {#name}
      # - {#title}
      # - {#abstract}
      class Presentation < ApplicationRecord
        default_scope { includes(:translations) }

        # @!attribute [rw] title
        #   @return [String, nil] the presentation title
        # @!attribute [rw] abstract
        #   @return [String, nil] the presentation abstract
        translates :title, :abstract, fallbacks: true

        # @return [ActiveRecord::Relation] all conferences, ordered by date
        scope :sorted, -> { order start_datetime: :desc }

        # @!attribute [rw] name
        #   @return [String, nil] the presentation title (alias)
        #   @see #title
        alias_attribute :name, :title

        # @!attribute [rw] session
        #   @return [Session, nil] directly associated session
        #   @see Session
        belongs_to :session, -> { includes(:translations) }, inverse_of: :presentations, touch: true
        # @!attribute [rw] presentation_type
        #   @return [PresentationType, nil] Presentation type associated with {#session}
        #   @see PresentationType
        #   @see Session#presentation_type
        has_one :presentation_type, -> { includes(:translations) }, through: :session
        # @!attribute [rw] room
        #   @return [Room, nil] Room associated with {#session}
        #   @see Session
        #   @see Session#room
        has_one :room, -> { includes(:translations) }, through: :session
        # @!attribute [rw] conference
        #   @return [Conference, nil] Conference associated with {#presentation_type}
        #   @see Conference
        #   @see PresentationType#conference
        has_one :conference, -> { includes(:translations) }, through: :presentation_type
        # @!attribute [rw] attachments
        #   @return [ActiveRecord::Relation] directly associated presentation attachments
        #   @note This relation accepts nested attributes.
        #   @note Destroying a presentation destroys associated attachments.
        #   @see Attachment
        has_many :attachments, class_name: 'Spina::Admin::Conferences::PresentationAttachment', dependent: :destroy,
                               inverse_of: :presentation
        # @!attribute [rw] presenters
        #   @return [ActiveRecord::Relation] directly associated delegates
        #   @see Delegate
        has_and_belongs_to_many :presenters, class_name: 'Spina::Admin::Conferences::Delegate', # rubocop:disable Rails/HasAndBelongsToMany
                                             foreign_key: :spina_conferences_presentation_id,
                                             association_foreign_key: :spina_conferences_delegate_id
        accepts_nested_attributes_for :attachments, allow_destroy: true

        validates :title, :date, :start_time, :start_datetime, :abstract, :presenters, presence: true
        validates :date, 'spina/admin/conferences/conference_date': true
        validates_associated :presenters
        validates_associated :attachments

        # Imports a presentation from CSV.
        # @param file [String] the CSV file to be read
        # @return [void]
        # @see PresentationImportJob#perform
        def self.import(file)
          PresentationImportJob.perform_later IO.read(file)
        end

        # @return [Date, nil] the start date of the presentation. Nil if the presentation has no start date and time
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

        # @return [ActiveSupport::TimeWithZone, nil] the start time of the presentation. Nil if the presentation has no start date and time
        def start_time
          return if start_datetime.blank?

          start_datetime
        end

        # Sets the start time of the presentation.
        # @param start_time [ActiveSupport::TimeWithZone] the new start time
        # @return [void]
        def start_time=(start_time)
          if start_time.blank?
            self.start_datetime = nil
            return
          end

          self.start_datetime = Time.parse(start_time, date).to_datetime.in_time_zone
        end

        # @return [Icalendar::Event] the presentation as an iCal event
        def to_event # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          event = Icalendar::Event.new
          return event if invalid?

          event.dtstart = start_datetime
          event.dtend = start_datetime + presentation_type.duration
          event.location = session.room_name
          presenters.each { |presenter| event.contact = presenter.full_name_and_institution }
          event.categories = Presentation.model_name.human(count: 0)
          event.summary = title
          event.append_custom_property('alt_description', abstract.try(:html_safe))
          event.description = abstract.try(:gsub, %r{</?[^>]*>}, '')
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
