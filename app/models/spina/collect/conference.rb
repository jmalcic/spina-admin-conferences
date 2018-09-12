# frozen_string_literal: true

module Spina
  module Collect
    # This class represents conferences.
    # A `Conference` has many `:presentations` (being presented at the
    # conference) and many `:delegates` (attending the conference), but a
    # `Delegate` can attend more than one `Conference`. Destroying a
    # `Conference` destroys the associated `:presentations`, but `:delegates`
    # remain. The `:finish_date` is validated to make sure it is after the
    # `:start_date`. A `Conference` also has a `:conference_page_part`, which
    # is destroyed with the `Conference`.
    class Conference < ApplicationRecord
      belongs_to :institution
      has_many :presentations, dependent: :destroy
      has_many :rooms, through: :institution
      has_many :presentation_types, dependent: :destroy
      has_and_belongs_to_many :delegates,
                              foreign_key: :spina_collect_conference_id,
                              association_foreign_key: :spina_collect_delegate_id

      validates_presence_of :start_date, :finish_date
      validates :finish_date, finish_date: true, unless: (proc do |a|
        a.dates.blank?
      end)

      scope :sorted, -> { order dates: :desc }

      # Returns the `:name` of the associated `:institution` and `#year`,
      # commonly used to identify a conference.
      def institution_and_year
        "#{institution.name} #{dates.begin.year}"
      end

      # Returns year of start date.
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
        finish_date = Date.parse(date)
        if dates
          assign_attributes(dates: dates.begin...finish_date)
        else
          assign_attributes(dates: finish_date.prev_day...finish_date)
        end
      end
    end
  end
end
