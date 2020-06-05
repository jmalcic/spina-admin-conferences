# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents dietary requirements.
      # A `DietaryRequirement` belongs to many `:delegates`, and a `Delegate` may have many `:dietary_requirements`.
      class DietaryRequirement < ApplicationRecord
        translates :name, fallbacks: true

        scope :sorted, -> { i18n.order :name }

        has_and_belongs_to_many :delegates, foreign_key: :spina_conferences_dietary_requirement_id,
                                            association_foreign_key: :spina_conferences_delegate_id

        validates :name, presence: true
      end
    end
  end
end
