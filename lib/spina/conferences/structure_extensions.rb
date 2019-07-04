# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    module StructureExtensions
      extend ActiveSupport::Concern

      def base_part
        part || page_part
      end
    end
  end
end
