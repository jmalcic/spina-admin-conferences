# frozen_string_literal: true

class IntervalType < ActiveRecord::Type::Value
  def cast_value(value)
    case value
    when ::ActiveSupport::Duration
      value
    when ::String
      ::ActiveSupport::Duration.parse(value)
    else
      super
    end
  end

  def serialize(value)
    case value
    when ::ActiveSupport::Duration
      value.iso8601
    when ::Numeric
      value.seconds.iso8601
    else
      super
    end
  end
end