# frozen_string_literal: true

require 'spina'
require 'opal-rails'
require 'opal-sprockets'
require 'active_record/pg_interval_rails_5_1'

module Spina
  module Collect
    class Engine < ::Rails::Engine
      isolate_namespace Spina::Collect

      config.before_initialize do
        ::Spina::Plugin.register do |plugin|
          plugin.name = 'collect'
          plugin.namespace = 'collect'
        end
      end
    end
  end
end
