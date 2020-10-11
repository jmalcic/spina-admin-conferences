# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Dietary requirement records.
      #
      # = Validators
      # Presence:: {#name}.
      #
      # = Translations
      # - {#name}
      class DietaryRequirement < ApplicationRecord
        default_scope { includes(:translations) }

        # @!attribute [rw] name
        #   @return [String, nil] the name of the dietary requirement
        translates :name, fallbacks: true

        # @return [ActiveRecord::Relation] all dietary requirements, ordered by name
        scope :sorted, -> { i18n.order :name }

        # @!attribute [rw] delegates
        #   @return [ActiveRecord::Relation] directly associated delegates
        #   @see Delegate
        has_and_belongs_to_many :delegates, foreign_key: :spina_conferences_dietary_requirement_id, # rubocop:disable Rails/HasAndBelongsToMany
                                            association_foreign_key: :spina_conferences_delegate_id

        validates :name, presence: true
      end
    end
  end
end
