# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents conference presentations.
      class Presentation < ApplicationRecord
        translates :title, :abstract, fallbacks: true

        scope :sorted, -> { order start_datetime: :desc }

        alias_attribute :name, :title

        belongs_to :session, inverse_of: :presentations
        has_one :presentation_type, through: :session
        has_one :room, through: :session
        has_one :conference, through: :presentation_type
        has_many :presentation_attachments, dependent: :destroy
        has_and_belongs_to_many :presenters, class_name: 'Spina::Admin::Conferences::Delegate',
                                             foreign_key: :spina_conferences_presentation_id,
                                             association_foreign_key: :spina_conferences_delegate_id

        validates :title, :date, :start_time, :start_datetime, :abstract, :presenters, presence: true
        validates :date, 'spina/admin/conferences/conference_date': true
        validates_associated :presenters

        def self.import(file)
          PresentationImportJob.perform_later IO.read(file)
        end

        def date
          return if start_datetime.blank?

          start_datetime.to_date
        end

        def date=(date)
          if date.blank? || date.to_date.blank?
            self.start_datetime = nil
            return
          end

          self.start_datetime = date.to_date + (start_datetime.try(:seconds_since_midnight) || 0).seconds
        end

        def start_time
          return if start_datetime.blank?

          start_datetime
        end

        def start_time=(start_time)
          if start_time.blank?
            self.start_datetime = nil
            return
          end

          self.start_datetime = Time.parse(start_time, date).to_datetime.in_time_zone
        end

        # rubocop:disable Metrics/AbcSize

        def to_ics
          event = Icalendar::Event.new
          return event if invalid?

          event.dtstart = start_datetime
          event.dtend = start_datetime + presentation_type.duration
          event.location = session.room_name
          presenters.each { |presenter| event.contact = presenter.full_name_and_institution }
          event.categories = self.class.name.demodulize.upcase
          event.summary = title
          event.description = abstract.try(:html_safe)
          event
        end

        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
