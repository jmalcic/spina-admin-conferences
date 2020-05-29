# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class Engine < ::Rails::Engine #:nodoc:
        config.before_initialize do
          ::Spina::Plugin.register do |plugin|
            plugin.name = 'conferences'
            plugin.namespace = 'conferences'
          end
        end
      end
    end
  end
end
