# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # Adds method returning the relevant part type
    module StructureExtensions
      extend ActiveSupport::Concern

      def base_part
        part || page_part
      end
    end
  end
end
