# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # Classes which act like pages
    module Pageable
      extend ActiveSupport::Concern

      def model_config(conferences_theme)
        conferences_theme.models[self.class.name.to_sym]
      end

      def model_parts(theme)
        conferences_theme = Conferences::THEMES.find { |conference_theme| conference_theme.name == theme.name }
        theme.page_parts.select { |page_part| page_part[:name].in? model_config(conferences_theme)[:parts] }
      end
    end
  end
end
