# frozen_string_literal: true

require 'webpacker'

module Spina
  module Admin
    module Conferences
      module ApplicationHelper #:nodoc:
        include ::Webpacker::Helper

        def current_webpacker_instance
          ::Spina::Conferences::Engine.webpacker
        end
      end
    end
  end
end
