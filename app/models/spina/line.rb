module Spina
  class Line < ApplicationRecord
    extend Mobility
    translates :content

    has_many :page_parts, as: :page_partable
    has_many :parts, as: :partable, class_name: 'Spina::Conferences::Part'
    has_many :layout_parts, as: :layout_partable
    has_many :structure_parts, as: :structure_partable
  end
end
