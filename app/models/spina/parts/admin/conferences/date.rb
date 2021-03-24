# frozen_string_literal: true

module Spina
  module Parts
    module Admin
      module Conferences
        # Date parts, without associated times.
        class Date < Spina::Parts::Base
          attr_json :content, :date
        end
      end
    end
  end
end
