# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

module Spina
  module Conferences
    class FrontendHelperTest < ActionView::TestCase
      setup do
        def request
          controller.request
        end
      end

      test 'should return main navigation' do
        navigation_items = ::Spina::Navigation.find_by(name: 'main').navigation_items.roots.joins(:page)
                                              .where(spina_pages: { resource_id: nil }).active.in_menu.sorted.live
        navigation_item_elements = navigation_items.inject(String.new) do |buffer, item|
          url = item.materialized_path
          buffer << %(<a class="#{('test-3' if current_page?(url)) || 'test-2'}" href="#{url}">#{item.menu_title}</a>)
        end
        assert_dom_equal %(<nav class="test">#{navigation_item_elements}</nav>),
                         main_navigation(request, css: { menu: 'test', link: 'test-2', inactive_link: 'test-3' })
      end

      test 'should return footer navigation' do
        navigation_items = ::Spina::Navigation.find_by(name: 'footer').navigation_items.roots.joins(:page)
                                              .where(spina_pages: { resource_id: nil }).active.in_menu.sorted.live
        navigation_item_elements = navigation_items.inject(String.new) do |buffer, item|
          url = item.materialized_path
          buffer << %(<a class="#{('test-3' if current_page?(url)) || 'test-2'}" href="#{url}">#{item.menu_title}</a>)
        end
        assert_dom_equal %(<nav class="test">#{navigation_item_elements}</nav>),
                         footer_navigation(request, css: { menu: 'test', link: 'test-2', inactive_link: 'test-3' })
      end

      test 'should return latest conference' do
        assert_equal Conference.order(dates: :desc).first, latest_conference
      end
    end
  end
end
