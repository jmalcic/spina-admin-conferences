# frozen_string_literal: true

require 'webpacker'

module Spina
  module Admin
    module Conferences
      module ApplicationHelper #:nodoc:
        include ::Webpacker::Helper

        helper_methods = ::Webpacker::Helper.public_instance_methods false
        helper_methods.delete :current_webpacker_instance
        helper_methods.each do |method|
          alias_method :"base_#{method}", :"#{method}"
          redefine_method method do |*args, **options|
            update_webpacker_instance options.delete(:instance)
            send :"base_#{method}", *args, **options
          end
        end

        private

        def update_webpacker_instance(instance)
          @webpacker = instance || Webpacker.instance
        end

        def current_webpacker_instance
          @webpacker || Webpacker.instance
        end
      end
    end
  end
end
