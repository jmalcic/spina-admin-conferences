# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conferences.
    class Conference < ApplicationRecord
      include ConferencePagePartable

      before_validation :set_up_room_possessions, on: [:create, :save]

      belongs_to :institution, inverse_of: :conferences
      has_many :room_possessions, dependent: :destroy
      has_many :rooms, through: :room_possessions
      has_many :presentation_types, dependent: :destroy
      has_many :presentations, through: :presentation_types
      has_and_belongs_to_many :delegates,
                              foreign_key: :spina_conferences_conference_id,
                              association_foreign_key:
                                  :spina_conferences_delegate_id

      validates_presence_of :start_date, :finish_date
      validates :finish_date, finish_date: true, unless: (proc do |a|
        a.dates.blank?
      end)

      scope :sorted, -> { order dates: :desc }

      # Returns the `:name` of the associated `:institution` and `#year`,
      # commonly used to identify a conference.
      def institution_and_year
        "#{institution.name} #{year}"
      end

      # `#name` is used by the `:conference_page_part` to create a
      # `ConferencePage`
      alias name institution_and_year

      # `#parent_page` is used by the `:conference_page_part` to create a
      # `Resource`
      def self.parent_page
        Spina::Page.find_by(name: name.demodulize.parameterize.pluralize)
      end

      # `#view_template` is used by the `:conference_page_part` to create a
      # `Resource`
      def self.view_template
        name.demodulize.parameterize.pluralize
      end

      # Returns the year of `#start_date`.
      def year
        dates.begin.year
      end

      # Returns the beginning of the range of `:dates` the conference occurs,
      # or else today's date.
      def start_date
        dates&.begin || nil
      end

      # Returns the end of the range of `:dates` the conference occurs,
      # or else tomorrow's date.
      def finish_date
        dates&.end || nil
      end

      # Sets the beginning of the range of `:dates` the conference occurs,
      # or else the beginning and end of the range if the range is
      # missing entirely.
      def start_date=(date)
        return unless date
        start_date = Date.parse(date)
        if dates
          assign_attributes(dates: start_date...dates.end)
        else
          assign_attributes(dates: start_date...start_date.next_day)
        end
      end

      # Sets the end of the range of `:dates` the conference occurs,
      # or else the beginning and end of the range if the range is
      # missing entirely.
      def finish_date=(date)
        return unless date
        finish_date = Date.parse(date)
        if dates
          assign_attributes(dates: dates.begin...finish_date)
        else
          assign_attributes(dates: finish_date.prev_day...finish_date)
        end
      end

      def set_up_room_possessions
        institution.rooms.each do |room|
          rooms << room
        end
      end
    end
  end
end
