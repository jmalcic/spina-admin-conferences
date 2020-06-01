# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class ApplicationController < ::Spina::Admin::AdminController #:nodoc:
        add_flash_types :success

        layout 'spina/admin/admin', only: %i[new edit]
      end
    end
  end
end
