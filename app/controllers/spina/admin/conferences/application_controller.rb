# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # @abstract Subclass to implement a custom controller.
      class ApplicationController < ::Spina::Admin::AdminController
        helper ::Spina::Engine.routes.url_helpers

        add_flash_types :success

        layout 'spina/admin/conferences/application', only: %i[new edit]
        before_action :set_locale

        private

        def set_locale
          @locale = params[:locale] || I18n.default_locale
          Mobility.locale = @locale
        end
      end
    end
  end
end
