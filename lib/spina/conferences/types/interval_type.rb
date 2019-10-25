# frozen_string_literal: true

module Spina
  module Conferences
    # This type maps between ActiveSupport::Duration and interval in PostgreSQL
    class IntervalType < ActiveRecord::Type::Value
      def cast(value)
        case value
        when ::ActiveSupport::Duration
          value
        when ::String
          ::ActiveSupport::Duration.parse(value)
        else
          super
        end
      rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
        nil
      end

      def serialize(value)
        case value
        when ::ActiveSupport::Duration
          value.iso8601
        else
          super
        end
      end
    end
  end
end