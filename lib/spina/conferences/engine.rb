# frozen_string_literal: true

module Spina
  module Conferences
    class Engine < ::Rails::Engine #:nodoc:
      isolate_namespace Spina::Conferences

      config.before_initialize do
        ::Spina::Plugin.register do |plugin|
          plugin.name = 'conferences'
          plugin.namespace = 'conferences'
        end
      end

      config.to_prepare do
        # Load helpers from engine
        Spina::ApplicationController.helper 'spina/conference_pages'
      end
    end
  end
end
