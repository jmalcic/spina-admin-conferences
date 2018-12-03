# frozen_string_literal: true

require 'spina'
require 'opal-rails'
require 'opal-sprockets'
require 'opal-browser'
require 'dotenv-rails'
require 'uglifier'

module Spina
  module Conferences
    require 'spina/conferences/engine'
  end
end
