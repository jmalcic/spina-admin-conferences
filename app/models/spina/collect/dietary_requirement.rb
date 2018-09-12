# frozen_string_literal: true

module Spina
  module Collect
    # This class represents dietary requirements.
    # A `DietaryRequirement` belongs to many `:delegates`, and a `Delegate` may
    # have many `:dietary_requirements`.
    class DietaryRequirement < ApplicationRecord
      has_and_belongs_to_many :delegates,
                              foreign_key:
                                :spina_collect_dietary_requirement_id,
                              association_foreign_key:
                                :spina_collect_delegate_id

      validates_presence_of :name

      scope :sorted, -> { order :name }
    end
  end
end
