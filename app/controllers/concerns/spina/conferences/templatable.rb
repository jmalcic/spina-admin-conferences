# frozen_string_literal: true

module Spina
  module Conferences
    # This module supports rendering events as iCal
    module Templatable
      extend ActiveSupport::Concern

      class_methods do
        private

        def local_prefixes
          super + ["conference/#{controller_path}"]
        end
      end
    end
  end
end
