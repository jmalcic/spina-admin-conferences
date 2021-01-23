# frozen_string_literal: true

require 'simplecov'

if ENV['CI']
  require 'simplecov-lcov'

  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
end

SimpleCov.start 'rails' do
  enable_coverage :branch
  add_group 'Validators', 'app/validators'
end

require 'minitest/mock'
require 'minitest/reporters'

Minitest::Reporters.use!

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
  ActiveSupport::TestCase.file_fixture_path = "#{ActiveSupport::TestCase.fixture_path}/files"
  ActiveSupport::TestCase.fixtures :all
end

ActiveRecord::FixtureSet.context_class.include ActiveSupport::Testing::FileFixtures
ActiveRecord::FixtureSet.context_class.file_fixture_path = ActiveSupport::TestCase.file_fixture_path

module ActiveSupport
  class TestCase
    parallelize workers: :number_of_processors
    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name} worker #{worker}"
    end
    parallelize_teardown do
      SimpleCov.result
    end

    setup { I18n.locale = I18n.default_locale }
  end
end
