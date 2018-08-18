require 'spina'
require 'opal-rails'
require 'opal-sprockets'
require 'active_record/pg_interval_rails_5_1'

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
