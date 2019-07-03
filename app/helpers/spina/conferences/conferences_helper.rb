# frozen_string_literal: true

module Spina
  module Conferences
    module ConferencesHelper #:nodoc:
      include FrontendHelper

      def ancestors
        @conference&.ancestors || nil
      end

      def description
        @conference&.description || Conference.description
      end

      def seo_title
        @conference&.seo_title || Conference.seo_title
      end

      def menu_title
        @conference&.menu_title || Conference.menu_title
      end

      def part(name)
        part!(name) || 'shared/blank'
      end

      def part!(name)
        @conference.parts.find_by(name: name)
      end
    end
  end
end
