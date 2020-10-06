# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Room records.
      #
      # = Validators
      # Presence:: {#number}, {#building}.
      #
      # = Translations
      # - {#number}
      # - {#building}
      class Room < ApplicationRecord
        # @!attribute [rw] number
        #   @return [String, nil] the number of the room
        # @!attribute [rw] building
        #   @return [String, nil] the building of the room
        translates :building, :number, fallbacks: true

        # @return [ActiveRecord::Relation] all rooms, ordered by building and number
        scope :sorted, -> { i18n.order :building, :number }

        # @!attribute [rw] institution
        #   @return [Institution, nil] directly associated institution
        #   @see Institution
        belongs_to :institution, inverse_of: :rooms, autosave: true, touch: true
        # @!attribute [rw] sessions
        #   @return [ActiveRecord::Relation] directly associated sessions
        #   @note A room cannot be destroyed if it has dependent sessions.
        #   @see Session
        has_many :sessions, inverse_of: :room, dependent: :restrict_with_error
        # @!attribute [rw] presentations
        #   @return [ActiveRecord::Relation] Presentations associated with {#sessions}
        #   @see Presentation
        #   @see Session#presentations
        has_many :presentations, -> { distinct }, through: :sessions

        validates :number, :building, presence: true

        # @return [String] the building and number of the room
        def name
          return if building.blank? || number.blank?

          Room.human_attribute_name :name, building: building, number: number
        end
      end
    end
  end
end
