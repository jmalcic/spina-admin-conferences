# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Admin
    module Conferences
      # Adds part association for Spina partables
      module PagesHelperExtensions
        extend ActiveSupport::Concern
  
        included do
          redefine_method :link_to_add_structure_item_fields do |f, &block|
            item = StructureItem.new
            fields = f.fields_for(:structure_items, item, child_index: item.object_id) do |builder|
              build_structure_parts(f.object.base_part.name, item)
              render("spina/admin/structure_items/fields", f: builder)
            end
            link_to '#', class: "add_structure_item_fields button button-link", data: {id: item.object_id, fields: fields.gsub("\n", "")} do
              icon('plus')
            end
          end
        end
      end
    end
  end
end
