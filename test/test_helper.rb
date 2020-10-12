# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
SimpleCov.start 'rails' do
  enable_coverage :branch
  add_group 'Validators', 'app/validators'
end

Coveralls.wear!('rails')

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
    teardown { I18n.locale = I18n.default_locale }
  end
end

module RemoveUploadedFiles
  def before_setup
    super
    upload_files
  end

  def after_teardown
    super
    remove_uploaded_files
  end

  private

  def upload_files
    Spina::Image.all.each do |image|
      unless image.file.attached?
        file_fixture('dubrovnik.jpeg').then { |fixture| image.file.attach io: fixture.open, filename: fixture.basename }
      end
    end
    Spina::Attachment.all.each do |attachment|
      unless attachment.file.attached?
        file_fixture('handout.pdf').then { |fixture| attachment.file.attach io: fixture.open, filename: fixture.basename }
      end
    end
  end

  def remove_uploaded_files
    Spina::Image.all.each { |image| image.file.purge }
    Spina::Attachment.all.each { |attachment| attachment.file.purge }
  end
end

module ActionDispatch
  class IntegrationTest
    prepend RemoveUploadedFiles
  end
end
