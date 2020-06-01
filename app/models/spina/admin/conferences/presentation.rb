# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents conference presentations.
      class Presentation < ApplicationRecord
        translates :title, :abstract, fallbacks: true

        after_initialize :set_from_start_datetime
        before_validation :update_start_datetime

        attribute :date, :date
        attribute :start_time, :time

        belongs_to :session, inverse_of: :presentations
        has_one :presentation_type, through: :session
        has_one :room, through: :session
        has_one :conference, through: :presentation_type
        has_many :presentation_attachments, dependent: :destroy
        has_and_belongs_to_many :presenters, class_name: 'Spina::Admin::Conferences::Delegate',
                                             foreign_key: :spina_conferences_presentation_id,
                                             association_foreign_key: :spina_conferences_delegate_id

        validates :title, :date, :start_time, :abstract, :presenters, presence: true
        validates :date, 'spina/admin/conferences/conference_date': true
        validates_associated :presenters

        scope :sorted, -> { order start_datetime: :desc }

        alias_attribute :name, :title

        def self.import(file)
          PresentationImportJob.perform_later IO.read(file)
        end

        def self.description
          nil
        end

        def self.seo_title
          'Presentations'
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

        def description
          content('abstract') || nil
        end

        alias seo_title name

        def ancestors
          [conference]
        end

        alias menu_title name

        private

        def set_from_start_datetime
          return if start_datetime.blank?

          self.date ||= start_datetime.to_date
          self.start_time ||= start_datetime
        end

        def update_start_datetime
          self.start_datetime = "#{date} #{start_time}".to_time.in_time_zone if date.present? && start_time.present?
        end
      end
    end
  end
end
