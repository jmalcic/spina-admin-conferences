# frozen_string_literal: true

module Spina
  module Conferences
    class Engine < ::Rails::Engine #:nodoc:
      isolate_namespace Spina::Conferences
      paths['public'] = 'public'

      config.before_initialize do
        ::Spina::Plugin.register do |plugin|
          plugin.name = 'conferences'
          plugin.namespace = 'conferences'
        end
      end

      config.to_prepare do
        # Load helpers from engine
        Spina::ApplicationController.helper 'spina/conferences/conference_pages', 'spina/conferences/application',
                                            'spina/admin/conferences/application'
      end

      config.after_initialize do
        @webpacker = ::Webpacker::Instance.new root_path: root
      end

      config.app_middleware.use ::ActionDispatch::Static, paths['public'].first

      class << self
        attr_reader :webpacker
      end
    end
  end
end
