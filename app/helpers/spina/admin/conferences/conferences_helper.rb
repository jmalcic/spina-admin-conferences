# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Helper for conferences
      module ConferencesHelper
        STRUCTURES = [
          { name: 'sponsors', structure_parts: [
            { name: 'name', title: 'Name', partable_type: 'Spina::Line' },
            { name: 'logo', title: 'Logo', partable_type: 'Spina::Image' },
            { name: 'website', title: 'Website', partable_type: 'Spina::Admin::Conferences::UrlPart' }
          ] }
        ].freeze

        def new_custom_structure_item(form, part)
          item = StructureItem.new
          build_custom_structure_parts(part.name, item)
          fields = form.fields_for(:structure_items, item, child_index: item.object_id) do |builder|
            render('spina/admin/conferences/conferences/form_structure_item', f: builder, structure: part)
          end
          link_to icon('plus'), '#', class: %w[add_structure_item_fields button button-link],
                                     data: { id: item.object_id, fields: fields.squish }
        end

        def build_custom_structure_parts(name, item)
          structure = STRUCTURES.find { |structure_attributes| structure_attributes[:name] == name }
          return item.parts if structure.blank?

          structure[:structure_parts].map do |part_attributes|
            item.parts.where(name: part_attributes[:name]).first_or_initialize(**part_attributes).then do |part|
              part.partable ||= part.partable_type.constantize.new
              part
            end
          end
        end
      end
    end
  end
end
