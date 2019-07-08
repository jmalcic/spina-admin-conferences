# frozen_string_literal: true

module Spina
  module Conferences
    # Renders navigation elements from navigations
    class MenuPresenter
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActiveSupport::Configurable

      # Configuration
      config_accessor :output_buffer, :depth # root nodes are at depth 0

      def initialize(collection, request, css)
        @collection = collection
        @request = request
        @css = css
      end

      def to_html
        render_menu
      end

      private

      def render_menu
        content_tag(:nav, class: @css[:menu]) { render_items }
      end

      def render_items
        scoped_collection.inject(ActiveSupport::SafeBuffer.new) { |buffer, item| buffer << render_item(item) }
      end

      def render_item(item)
        link_to item.menu_title, item.materialized_path, class: [@css[:link], (@css[:inactive_link] if current_page?)]
      end

      def scoped_collection
        @collection.navigation_items.roots.joins(:page).where(spina_pages: { resource_id: nil }).active.in_menu.sorted
          .live
      end
    end
  end
end
