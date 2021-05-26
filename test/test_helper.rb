# frozen_string_literal: true

require 'simplecov'

if ENV['CI']
  require 'simplecov-lcov'

  SimpleCov::Formatter::LcovFormatter.config do |config|
    config.report_with_single_file = true
  end

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
    parallelize

    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name} worker #{worker}"
    end

    parallelize_teardown do
      SimpleCov.result
    end

    setup { I18n.locale = I18n.default_locale }
  end
end

module StorageHelpers
  module ::ActiveStorage
    class FixtureSet
      include ActiveSupport::Testing::FileFixtures
      include ActiveRecord::SecureToken

      def self.blob(filename:, **attributes)
        new.prepare ActiveStorage::Blob.new(filename: filename, key: generate_unique_secure_token), **attributes
      end

      def prepare(instance, **attributes)
        io = file_fixture(instance.filename.to_s).open
        instance.unfurl(io)
        instance.assign_attributes(attributes)
        instance.upload_without_unfurling(io)

        instance.attributes.transform_values { |value| value.is_a?(Hash) ? value.to_json : value }.compact.to_json
      end
    end

    ::ActiveStorage::FixtureSet.file_fixture_path = "#{ActiveSupport::TestCase.fixture_path}/files"
  end
end

ActiveRecord::FixtureSet.context_class.include StorageHelpers
