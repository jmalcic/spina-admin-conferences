# frozen_string_literal: true

require 'spina'
require 'spina/admin/conferences/engine'
require 'rails-i18n'
require 'icalendar'

module Spina
  module Admin
    module Conferences #:nodoc:
      def self.table_name_prefix
        'spina_conferences_'
      end
    end
  end
end
