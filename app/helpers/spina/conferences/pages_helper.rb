# frozen_string_literal: true

module Spina
  module Conferences
    module PagesHelper #:nodoc:
      include FrontendHelper

      def ancestors
        @page.ancestors
      end

      def description
        @page.description
      end

      def seo_title
        @page.seo_title
      end

      def menu_title
        @page.menu_title
      end

      def part(name)
        part!(name) || 'shared/blank'
      end

      def part!(name)
        @page.page_parts.find_by(name: name)
      end
    end
  end
end
