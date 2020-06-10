# frozen_string_literal: true

require 'minitest/mock'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

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

ActiveRecord::FixtureSet.context_class.include ActiveSupport::Testing::FileFixtures
ActiveRecord::FixtureSet.context_class.file_fixture_path = ActiveSupport::TestCase.file_fixture_path

module ActiveSupport
  class TestCase
    parallelize workers: 2 unless /rubymine/.match? ENV['XPC_SERVICE_NAME']

    setup do
      Spina::Image.all.each do |image|
        unless image.file.attached?
          fixture = file_fixture('dubrovnik.jpeg')
          image.file.attach io: fixture.open, filename: fixture.basename
        end
      end
      Spina::Attachment.all.each do |attachment|
        unless attachment.file.attached?
          fixture = file_fixture('handout.pdf')
          attachment.file.attach io: fixture.open, filename: fixture.basename
        end
      end
      I18n.locale = I18n.default_locale
    end

    teardown { I18n.locale = I18n.default_locale }
  end
end
