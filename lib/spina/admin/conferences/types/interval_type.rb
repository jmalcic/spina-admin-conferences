# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This type maps between ActiveSupport::Duration and interval in PostgreSQL
      class IntervalType < ActiveRecord::Type::Value
        def cast(value)
          case value
          when ::ActiveSupport::Duration
            value
          when ::String
            ::ActiveSupport::Duration.parse(value)
          when ::Integer
            ::ActiveSupport::Duration.build(value)
          else
            nil
          end
        rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
          nil
        end

        def serialize(value)
          return unless value.class == ::ActiveSupport::Duration

          value.iso8601
        end
      end
    end
  end
end
