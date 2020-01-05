# frozen_string_literal: true

if /.*rubymine.*/.match? ENV['XPC_SERVICE_NAME']
  require 'simplecov'
  require 'minitest/reporters'

  SimpleCov.start 'rails'
  Minitest::Reporters.use!
end

if ENV['CODECOV_TOKEN']
  require 'simplecov'
  require 'codecov'

  SimpleCov.start 'rails'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'percy'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
require 'rails/test_help'

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + '/files'
  ActiveSupport::TestCase.fixtures :all
end
