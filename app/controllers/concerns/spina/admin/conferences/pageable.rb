# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Classes which act like pages
      module Pageable
        extend ActiveSupport::Concern

        private

        def model_parts(name)
          current_theme.page_parts.select { |page_part| page_part[:name].in? current_theme.models[name][:parts] }
        end
      end
    end
  end
end
