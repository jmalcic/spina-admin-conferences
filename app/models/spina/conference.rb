module Spina
  # This class represents conferences.
  # Conferences have many presentations (being presented at the conference)
  # and many delegates (attending the conference), but delegates can attend
  # more than one conference. Destroying a conference destroys the associated
  # presentations, but delegates remain.
  # The finish date is validated to make sure it is after the start date.
  class Conference < ApplicationRecord
    has_many :presentations, class_name: 'Spina::Presentation', foreign_key: 'spina_conference_id', dependent: :destroy
    has_and_belongs_to_many :delegates, class_name: 'Spina::Delegate', foreign_key: 'spina_conference_id', association_foreign_key: 'spina_delegate_id'

    validates_presence_of :institution, :city, :start_date, :finish_date
    validates :finish_date, finish_date: true, unless: proc { |a| a.finish_date.blank? || a.start_date.blank? }

    # Returns institution and year of start date, commonly used to identify
    # a conference.
    def institution_and_year
      "#{institution} #{start_date.year}"
    end

    # Returns all of the dates when the conference is taking place.
    def dates
      (start_date..finish_date).to_a
    end
  end
end
