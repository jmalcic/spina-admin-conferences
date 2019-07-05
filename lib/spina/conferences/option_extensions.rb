# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # Adds method returning the relevant part type
    module OptionExtensions
      extend ActiveSupport::Concern

      def part
        page_part || layout_part || structure_part || base_part
      end
    end
  end
end
