# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Classes which act like pages
      module Pageable
        extend ActiveSupport::Concern

        private

        def model_parts(klass)
          return nil if current_theme.models.blank?

          current_theme.page_parts.select { |part| part[:name].in? current_theme.models[klass.to_s.to_sym][:parts] }
        end
      end
    end
  end
end
