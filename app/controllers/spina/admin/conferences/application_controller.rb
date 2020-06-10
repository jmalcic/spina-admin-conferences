# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # @abstract Subclass to implement a custom controller.
      class ApplicationController < ::Spina::Admin::AdminController
        add_flash_types :success

        layout :admin_layout, only: %i[new edit]

        private

        def admin_layout
          'spina/admin/admin'
        end
      end
    end
  end
end
