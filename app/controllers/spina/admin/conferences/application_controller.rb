# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # @abstract Subclass to implement a custom controller.
      class ApplicationController < ::Spina::Admin::AdminController
        add_flash_types :success

        layout 'spina/admin/conferences/application', only: %i[new edit]
      end
    end
  end
end
