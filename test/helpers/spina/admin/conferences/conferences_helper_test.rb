# frozen_string_literal: true

require 'test_helper'
require 'haml/template'
require 'capybara/minitest'

module Spina
  module Admin
    module Conferences
      class ConferencesHelperTest < ActionView::TestCase
        include Capybara::Minitest::Assertions
        include Haml::Helpers
        include Spina::Admin::AdminHelper

        setup do
          @structure_item = spina_structure_items(:sponsor)
          @new_structure_item = StructureItem.new
          @part = spina_admin_conferences_parts(:sponsors)
          init_haml_helpers
        end

        test 'generates link to add new structure item' do
          controller.view_context_class.include Spina::Admin::PagesHelper
          controller.view_context_class.include Spina::Engine.routes.url_helpers
          builder = ActionView::Helpers::FormBuilder.new(:partable, @part.partable, self, {})
          self.output_buffer = new_custom_structure_item(builder, @part)
          assert_link href: '#', class: %w[add_structure_item_fields button button-link] do |link|
            assert_match(/[0-9]+/, link[:'data-id'])
            assert_not_nil link[:'data-fields']
            link.assert_selector 'i', class: %w[icon icon-plus]
          end
        end

        test 'builds structure parts for existing structure item' do
          @structure_item.parts.clear
          assert_difference -> { @structure_item.parts.size }, 3 do
            build_custom_structure_parts('sponsors', @structure_item)
          end
          assert @structure_item.parts.all?(&:valid?)
        end

        test 'builds structure parts for new structure item' do
          assert_difference -> { @new_structure_item.parts.size }, 3 do
            build_custom_structure_parts('sponsors', @new_structure_item)
          end
          assert @new_structure_item.parts.all?(&:valid?)
        end

        private

        def document_root_element
          Nokogiri::HTML::Document.parse(@output_buffer).root
        end

        def page
          Capybara::Node::Simple.new(document_root_element)
        end
      end
    end
  end
end
