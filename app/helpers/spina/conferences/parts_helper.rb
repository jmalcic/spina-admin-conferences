# frozen_string_literal: true

module Spina
  module Conferences
    module PartsHelper #:nodoc:
      def part(name)
        part!(name) || 'shared/blank'
      end

      def part!(name)
        parts_object.parts.find_by(name: name)
      end
    end
  end
end
