# frozen_string_literal: true

require 'spina'
require 'opal-rails'
require 'opal-sprockets'
require 'opal-browser'
require 'active_record/pg_interval_rails_5_1'
require 'dotenv-rails'
require 'uglifier'

module Spina
  module Conferences
    require 'spina/conferences/engine'
  end
end
