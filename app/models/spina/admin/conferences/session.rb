# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Sessuib records.
      #
      # = Validators
      # Presence:: {#name}.
      #
      # = Translations
      # - {#name}
      class Session < ApplicationRecord
        # @!attribute [rw] name
        #   @return [String, nil] the name of the session
        translates :name, fallbacks: true

        # @!attribute [rw] room
        #   @return [Room, nil] directly associated room
        belongs_to :room, inverse_of: :sessions
        # @!attribute [rw] room
        #   @return [PresentationType, nil] directly associated presentation type
        #   @see PresentationType
        belongs_to :presentation_type, inverse_of: :sessions
        # @!attribute [rw] conference
        #   @return [Conference, nil] Conference associated with {#presentation_type}
        #   @see Conference
        #   @see PresentationType#conference
        has_one :conference, through: :presentation_type
        # @!attribute [rw] institution
        #   @return [Institution, nil] Institution associated with {#room}
        #   @see Institution
        #   @see Room#institution
        has_one :institution, through: :room
        # @!attribute [rw] presentations
        #   @return [ActiveRecord::Relation] directly associated presentations
        #   @note A session cannot be destroyed if it has dependent presentations.
        #   @see Presentation
        has_many :presentations, inverse_of: :session, dependent: :restrict_with_error

        validates :name, presence: true

        # @!method room_name
        #   @return [String, nil] name of associated room
        #   @note Delegated to {#room}.
        delegate :name, to: :room, prefix: true, allow_nil: true
        # @!method presentation_type_name
        #   @return [String, nil] name of associated presentation type
        #   @note Delegated to {#presentation_type}.
        delegate :name, to: :presentation_type, prefix: true, allow_nil: true
      end
    end
  end
end
