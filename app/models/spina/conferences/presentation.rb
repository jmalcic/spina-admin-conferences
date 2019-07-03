# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conference presentations.
    class Presentation < ApplicationRecord
      include ConferencePagePartable
      include ::Spina::Partable
      include Pageable

      after_initialize :set_from_start_datetime
      before_validation :update_start_datetime
      after_save -> { parts.each(&:save) }

      attribute :date, :date
      attribute :start_time, :time

      belongs_to :room_use, touch: true
      has_one :presentation_type, through: :room_use
      has_one :room_possession, through: :room_use
      has_one :conference, through: :presentation_type
      has_and_belongs_to_many :presenters, class_name: 'Spina::Conferences::Delegate',
                                           foreign_key: :spina_conferences_presentation_id,
                                           association_foreign_key: :spina_conferences_delegate_id
      has_many :parts, dependent: :destroy, as: :pageable
      accepts_nested_attributes_for :parts, allow_destroy: true

      validates :title, :date, :start_time, :abstract, :presenters, presence: true
      validates :date, conference_date: true
      validates_associated :presenters

      scope :sorted, -> { order start_datetime: :desc }

      # `:name` is used by the `:conference_page_part` to create a `ConferencePage`
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
        event.dtstart = start_datetime
        event.dtend = start_datetime + presentation_type.duration
        event.location = room_use.room_name
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
