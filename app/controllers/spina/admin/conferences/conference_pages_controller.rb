# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages conference pages
      class ConferencePagesController < ::Spina::Admin::PagesController
        private

        def page_params
          params.require(:conference_page).permit!
        end
      end
    end
  end
end
