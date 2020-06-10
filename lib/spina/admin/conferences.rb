# frozen_string_literal: true

require 'spina'
require 'spina/admin/conferences/engine'
require 'rails-i18n'
require 'icalendar'

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
