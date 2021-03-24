# frozen_string_literal: true

module Spina
  module Parts
    module Admin
      module Conferences
        # Time parts.
        class Time < Spina::Parts::Base
          attr_json :content, :time
        end
      end
    end
  end
end
