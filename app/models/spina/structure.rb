module Spina
  class Structure < ApplicationRecord
    has_one :page_part, as: :page_partable
    has_one :part, as: :partable, class_name: 'Spina::Conferences::Part'
    has_many :structure_items

    after_save -> { structure_items.each(&:save) }

    accepts_nested_attributes_for :structure_items, allow_destroy: true

    def content
      self
    end

    def base_part
      part || page_part
    end
  end
end
