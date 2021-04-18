# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Engine class for the plugin. This is where the plugin is registered as a {Spina::Plugin} with {Spina}.
      # @note The +name+ and +namespace+ of the {Spina::Plugin} object is +'conferences'+ (for compatibility reasons).
      class Engine < ::Rails::Engine
        isolate_namespace Spina::Admin::Conferences

        config.before_initialize do
          ::Spina::Plugin.register do |plugin|
            plugin.name = 'conferences'
            plugin.namespace = 'conferences'
          end
        end

        config.after_initialize do
          Spina::Part.register(Spina::Parts::Admin::Conferences::Date)
          Spina::Part.register(Spina::Parts::Admin::Conferences::EmailAddress)
          Spina::Part.register(Spina::Parts::Admin::Conferences::Time)
          Spina::Part.register(Spina::Parts::Admin::Conferences::Url)
        end

        config.to_prepare do
          require 'mobility/action_text'
        end
      end
    end
  end
end
