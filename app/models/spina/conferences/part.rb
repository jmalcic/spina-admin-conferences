# frozen_string_literal: true

module Spina
  module Conferences
    class Part < ApplicationRecord
      include Spina::Part
      include Spina::Optionable

      belongs_to :pageable, polymorphic: true
      belongs_to :partable, polymorphic: true, optional: true

      accepts_nested_attributes_for :partable, allow_destroy: true

      validates :name, uniqueness: { scope: :pageable_id }
    end
  end
end
