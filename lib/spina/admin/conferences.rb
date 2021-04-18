# frozen_string_literal: true

require 'spina'
require 'spina/admin/conferences/engine'
require 'spina/admin/conferences/railtie' if defined?(Rails::Railtie)
require 'rails-i18n'
require 'stimulus-rails'
require 'turbo-rails'
require 'icalendar'
require 'icalendar/tzinfo'

# Spina content management system.
# @see https://www.spinacms.com Spina website
module Spina
  module Admin
    # Conference-management plugin for Spina.
    module Conferences
      def self.table_name_prefix
        'spina_conferences_'
      end
    end
  end
end
