# frozen_string_literal: true

module Spina
  module Conferences
    module MetadataHelper #:nodoc:
      def seo_description
        metadata_object.seo_description
      end

      def seo_title
        metadata_object.seo_title
      end

      def menu_title
        metadata_object.menu_title
      end      
    end
  end
end
