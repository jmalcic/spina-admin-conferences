# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conference presentations.
    class Presentation < ApplicationRecord
      include ConferencePagePartable

      after_initialize :set_start_datetime
      before_validation :update_start_datetime

      attribute :date, :date
      attribute :start_time, :time

      belongs_to :room_use, touch: true
      has_one :presentation_type, through: :room_use
      has_one :room_possession, through: :room_use
      has_one :conference, through: :presentation_type
      has_and_belongs_to_many :presenters, class_name: 'Spina::Conferences::Delegate',
                                           foreign_key: :spina_conferences_presentation_id,
                                           association_foreign_key: :spina_conferences_delegate_id

      validates :title, :date, :start_time, :abstract, :presenters, presence: true
      validates :date, conference_date: true
      validates_associated :presenters

      scope :sorted, -> { order start_datetime: :desc }

      # `:name` is used by the `:conference_page_part` to create a `ConferencePage`
      alias_attribute :name, :title

      def set_start_datetime
        return unless start_datetime

        self.date ||= start_datetime.to_date
        self.start_time ||= start_datetime
      end

      def update_start_datetime
        self.start_datetime = "#{date} #{start_time}".to_time.in_time_zone if date && start_time
      end
    end
  end
end
