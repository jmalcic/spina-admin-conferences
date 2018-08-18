module Spina
  # This class represents a presentation type (e.g. plenary, poster
  # presentation, etc.)
  # A presentation type has many presentations.
  class PresentationType < ApplicationRecord
    has_many :presentations,
             class_name: 'Spina::Presentation',
             foreign_key: 'spina_presentation_type_id'

    validates_presence_of :name, :minutes
    validates_numericality_of :minutes, greater_than_or_equal_to: 1

    scope :sorted, -> { order(:name) }

    def minutes
      duration / ActiveSupport::Duration::SECONDS_PER_MINUTE if duration
    end

    def minutes=(minutes)
      assign_attributes(duration: "PT#{minutes}M")
    end
  end
end
