require 'spina'
require 'opal-rails'
require 'opal-sprockets'

module Collect
  class Engine < ::Rails::Engine
    initializer 'spina.plugin.register.collect', before: :load_config_initializers do
      ::Spina::Plugin.register do |plugin|
        plugin.name       = 'Collect'
        plugin.namespace  = 'collect'
      end
    end
  end
end
