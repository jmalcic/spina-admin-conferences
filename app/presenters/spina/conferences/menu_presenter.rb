# frozen_string_literal: true

module Spina
  module Conferences
    class MenuPresenter
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActiveSupport::Configurable

      attr_reader :request
      attr_accessor :collection, :output_buffer

      # Configuration
      config_accessor :menu_tag, :menu_css,
                      :list_tag, :list_css,
                      :list_item_tag, :list_item_css,
                      :link_tag_css,
                      :include_drafts,
                      :depth, :inactive_link_tag_css # root nodes are at depth 0

      # Default configuration
      self.menu_tag = :nav
      self.list_tag = :ul
      self.list_item_tag = :li
      self.include_drafts = false

      def initialize(collection, request)
        @collection = collection
        @request = request
      end

      def to_html
        roots ? render_menu(roots) : nil
      end

      private

      def roots
        return @collection.navigation_items.roots if @collection.navigation_items&.roots&.present?

        nil
      end

      def render_menu(collection)
        content_tag(menu_tag, class: menu_css) do
          render_items(scoped_collection(collection))
        end
      end

      def render_items(collection)
        collection.inject(ActiveSupport::SafeBuffer.new) do |buffer, item|
          buffer << render_item(item)
        end
      end

      def render_item(item)
        link_to_unless_current item.menu_title, item.materialized_path,
                               class: link_tag_css, data: { page_id: item.page_id } do
          link_to item.menu_title, item.materialized_path,
                  class: inactive_link_tag_css,
                  data: { page_id: item.page_id }
        end
      end

      def scoped_collection(collection)
        scoped = collection.joins(:page).where(spina_pages: { resource_id: nil }).active.in_menu.sorted
        include_drafts ? scoped : scoped.live
      end

      def render_children?(item)
        return true unless depth
        item.depth < depth
      end
    end
  end
end
