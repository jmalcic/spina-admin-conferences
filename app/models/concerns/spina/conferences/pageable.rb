# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # Classes which act like pages
    module Pageable
      extend ActiveSupport::Concern

      class_methods do
        def model_parts(theme)
          theme.page_parts.select { |page_part| page_part[:name].in? theme.models[name.to_sym][:parts] }
        end
      end
    end
  end
end
