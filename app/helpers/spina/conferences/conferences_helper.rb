# frozen_string_literal: true

module Spina
  module Conferences
    module ConferencesHelper #:nodoc:
      include PageableHelper

      def ancestors
        return if @conference.blank?

        @conference.ancestors
      end

      private

      def metadata_object
        @conference || Conference
      end

      def parts_object
        @conference
      end
    end
  end
end
