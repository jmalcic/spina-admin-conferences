# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # Classes which act like pages
    module Pageable
      extend ActiveSupport::Concern

      class_methods do
        def model_config(conferences_theme)
          conferences_theme.models[name.to_sym]
        end

        def model_parts(theme)
          conferences_theme = Theme.find_by(name: theme.name)
          theme.page_parts.select { |page_part| page_part[:name].in? model_config(conferences_theme)[:parts] }
        end
      end
    end
  end
end
