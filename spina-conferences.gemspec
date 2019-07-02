# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'spina/conferences/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'spina-conferences'
  spec.version     = Spina::Conferences::VERSION
  spec.authors     = ['Justin Malčić']
  spec.email       = ['j.malcic@me.com']
  spec.homepage    = 'https://jmalcic.github.io/projects/spina-conferences'
  spec.summary     = 'Conference management plugin for Spina.'
  spec.description = 'Keep track of conference attendees and presentations with this plugin.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'icalendar', '~> 2.5'
  spec.add_dependency 'js-routes', '~> 1.4'
  spec.add_dependency 'octicons_helper', '~> 9.1'
  spec.add_dependency 'pg', '>= 0.18', '< 2.0'
  spec.add_dependency 'rails', '~> 6.0.0.rc1'
  spec.add_dependency 'rails-i18n', '~> 6.0.0.beta1'
  spec.add_dependency 'spina', '~> 1.0'
  spec.add_dependency 'webpacker', '~> 4.0'

  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'mini_racer'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'resque'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'web-console'
  spec.add_development_dependency 'webdrivers'
end
