module Spina
  # This class represents conferences.
  # Conferences have many presentations (being presented at the conference)
  # and many delegates (attending the conference), but delegates can attend
  # more than one conference. Destroying a conference destroys the associated
  # presentations, but delegates remain.
  # The finish date is validated to make sure it is after the start date.
  class Conference < ApplicationRecord
    has_many :presentations,
             class_name: 'Spina::Presentation',
             foreign_key: 'spina_conference_id',
             dependent: :destroy
    has_and_belongs_to_many :delegates,
                            class_name: 'Spina::Delegate',
                            foreign_key: 'spina_conference_id',
                            association_foreign_key: 'spina_delegate_id'

    validates_presence_of :institution, :city, :start_date, :finish_date
    validates :finish_date, finish_date: true, unless: (proc do |a|
      a.dates.blank?
    end)

    scope :sorted, -> { order(dates: :desc) }

    # Returns institution and year of start date, commonly used to identify
    # a conference.
    def institution_and_year
      "#{institution} #{dates.begin.year}"
    end

    # Returns the beginning of the range of dates the conference occurs,
    # or else today's date.
    def start_date
      dates&.begin || nil
    end

    # Returns the end of the range of dates the conference occurs,
    # or else tomorrow's date.
    def finish_date
      dates&.end || nil
    end

    # Sets the beginning of the range of dates the conference occurs,
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

    # Sets the end of the range of dates the conference occurs,
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
