# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conference presentations.
    class Presentation < ApplicationRecord
      include ConferencePagePartable

      belongs_to :room_use, touch: true
      has_one :presentation_type, through: :room_use
      has_one :room_possession, through: :room_use
      has_one :conference, through: :presentation_type
      has_and_belongs_to_many :presenters,
                              class_name: 'Spina::Conferences::Delegate',
                              foreign_key: :spina_conferences_presentation_id,
                              association_foreign_key:
                                  :spina_conferences_delegate_id

      validates_presence_of :title, :date, :start_time, :abstract, :presenters
      validates :start_time, conference_date: true,
                             unless: proc { |a| a.date.blank? }
      validates_associated :presenters

      scope :sorted, -> { order start_datetime: :desc }

      # `:name` is used by the `:conference_page_part` to create a
      # `ConferencePage`
      alias_attribute :name, :title

      # `#parent_page` is used by the `:conference_page_part` to create a
      # `Resource`
      def parent_page
        conference&.conference_page_part&.conference_page
      end

      # `#view_template` is used by the `:conference_page_part` to create a
      # `Resource`
      def self.view_template
        name.demodulize.parameterize.pluralize
      end

      def date
        start_datetime&.to_date
      end
      def date=(date)
        @date = date
      end
      def start_time
        start_datetime
      end
      def start_time=(time)
        @time = time
        return unless @date
        self.start_datetime = "#{@date} #{@time}".to_datetime.in_time_zone
      end
    end
  end
end
