module Spina
  # This class represents a dietary requirement.
  # Dietary requirements belong to delegates.
  class DietaryRequirement < ApplicationRecord
    has_and_belongs_to_many :delegates,
                            class_name: 'Spina::Delegate',
                            foreign_key: 'spina_dietary_requirement_id',
                            association_foreign_key: 'spina_delegate_id'

    validates_presence_of :name

    scope :sorted, -> { order(:name) }
  end
end
