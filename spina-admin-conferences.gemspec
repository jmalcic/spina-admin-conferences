# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'spina/admin/conferences/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name = 'spina-admin-conferences'
  spec.version = Spina::Admin::Conferences::VERSION
  spec.authors = ['Justin Malčić']
  spec.email = ['j.malcic@me.com']
  spec.homepage = 'https://jmalcic.github.io/projects/spina-admin-conferences'
  spec.summary = 'Conference management plugin for Spina.'
  spec.description = 'Keep track of conference attendees and presentations with this plugin.'
  spec.license = 'MIT'
  spec.required_ruby_version = '~> 2.7'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'babel-transpiler', '~> 0.7'
  spec.add_dependency 'icalendar', '~> 2.5'
  spec.add_dependency 'mobility', '~> 0.8.10'
  spec.add_dependency 'rails', '~> 6.0'
  spec.add_dependency 'rails-i18n', '~> 6.0'
  spec.add_dependency 'spina', '~> 1.1'

  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'coveralls_reborn'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'image_processing'
  spec.add_development_dependency 'mini_racer'
  spec.add_development_dependency 'minitest-rails'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'percy-capybara'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'sidekiq'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'web-console'
  spec.add_development_dependency 'webdrivers'
end
