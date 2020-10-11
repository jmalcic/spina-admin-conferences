# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Institution records.
      #
      # = Validators
      # Presence:: {#name}, {#city}.
      #
      # = Translations
      # - {#name}
      # - {#city}
      class Institution < ApplicationRecord
        default_scope { includes(:translations) }

        # @!attribute [rw] name
        #   @return [String, nil] the name of the institution
        # @!attribute [rw] city
        #   @return [String, nil] the city of the institution
        translates :name, :city, fallbacks: true

        # @return [ActiveRecord::Relation] all institutions, ordered by name
        scope :sorted, -> { i18n.order :name }

        # @!attribute [rw] logo
        #   @return [Spina::Image, nil] directly associated image
        belongs_to :logo, class_name: 'Spina::Image', optional: true
        # @!attribute [rw] rooms
        #   @return [ActiveRecord::Relation] directly associated rooms
        #   @note An institution cannot be destroyed if it has dependent rooms.
        #   @see Room
        has_many :rooms, -> { includes(:translations) }, inverse_of: :institution, dependent: :restrict_with_error
        # @!attribute [rw] delegates
        #   @return [ActiveRecord::Relation] directly associated delegates
        #   @note This relation accepts nested attributes.
        #   @note An institution cannot be destroyed if it has dependent delegates.
        #   @see Delegate
        has_many :delegates, inverse_of: :institution, dependent: :restrict_with_error
        accepts_nested_attributes_for :rooms

        validates :name, :city, presence: true
      end
    end
  end
end
