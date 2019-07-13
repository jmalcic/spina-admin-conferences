# frozen_string_literal: true

module Spina
  module Conferences
    module PresentationsHelper #:nodoc:
      include FrontendHelper
      include MetadataHelper
      include PartsHelper

      def ancestors
        return if @presentation.blank?

        @presentation.ancestors
      end

      private

      def metadata_object
        @presentation || Presentation
      end

      def parts_object
        @presentation
      end
    end
  end
end
