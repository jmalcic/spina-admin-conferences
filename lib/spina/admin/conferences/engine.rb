# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Engine class for the plugin. This is where the plugin is registered as a {Spina::Plugin} with {Spina}.
      # @note The +name+ and +namespace+ of the {Spina::Plugin} object is +'conferences'+ (for compatibility reasons).
      class Engine < ::Rails::Engine
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
