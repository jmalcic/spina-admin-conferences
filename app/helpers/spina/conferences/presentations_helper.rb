# frozen_string_literal: true

module Spina
  module Conferences
    module PresentationsHelper #:nodoc:
      include FrontendHelper

      def ancestors
        @presentation&.ancestors || nil
      end

      def description
        @presentation&.description || Presentation.description
      end

      def seo_title
        @presentation&.seo_title || Presentation.seo_title
      end

      def menu_title
        @presentation&.menu_title || Presentation.menu_title
      end

      def part(name)
        part!(name) || 'shared/blank'
      end

      def part!(name)
        @presentation.parts.find_by(name: name)
      end
    end
  end
end
