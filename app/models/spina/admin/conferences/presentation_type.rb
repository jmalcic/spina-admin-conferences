# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Presentation type records.
      #
      # = Validators
      # Presence:: {#name}, {#minutes}. {#duration}.
      #
      # = Translations
      # - {#name}
      class PresentationType < ApplicationRecord
        # @!attribute [rw] name
        #   @return [String, nil] the name of the presentation type
        translates :name, fallbacks: true

        # @return [ActiveRecord::Relation] all presentation types, ordered by name
        scope :sorted, -> { i18n.order :name }

        # @!attribute [rw] duration
        #   @return [ActiveSupport::Duration, nil] the duration of dependent presentations
        attribute :duration, :interval

        # @!attribute [rw] conference
        #   @return [Conference, nil] directly associated conference
        belongs_to :conference, inverse_of: :presentation_types
        # @!attribute [rw] sessions
        #   @return [ActiveRecord::Relation] directly associated sessions
        #   @note A presentation type cannot be destroyed if it has dependent sessions.
        #   @see Session
        has_many :sessions, inverse_of: :presentation_type, dependent: :restrict_with_error
        # @!attribute [rw] presentations
        #   @return [ActiveRecord::Relation] Presentations associated with {#sessions}
        #   @see Presentation
        #   @see Session#presentations
        has_many :presentations, -> { distinct }, through: :sessions

        validates :name, :minutes, :duration, presence: true
        validates :minutes, numericality: { greater_than_or_equal_to: 1 }

        # @return [Integer, nil] duration in minutes. Nil if the conference has no duration
        def minutes
          return if duration.blank?

          duration.to_i / ActiveSupport::Duration::PARTS_IN_SECONDS[:minutes]
        end

        # Sets the duration of the conference.
        # @param minutes [#to_i] the new duration in minutes
        # @return [void]
        def minutes=(minutes)
          self.duration = minutes.to_i.minutes
        end
      end
    end
  end
end
