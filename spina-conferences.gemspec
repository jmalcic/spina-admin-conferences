# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'spina/conferences/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'spina-conferences'
  s.version     = Spina::Conferences::VERSION
  s.authors     = ['Justin Malčić']
  s.email       = ['j.malcic@me.com']
  s.homepage    = 'https://jmalcic.github.io/projects/spina-conferences'
  s.summary     = 'Conference management plugin for Spina.'
  s.description = 'Keep track of conference attendees and presentations with'\
                  'this plugin.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE',
                'Rakefile', 'README.md']

  s.add_dependency 'opal-activesupport', '~> 0.3'
  s.add_dependency 'opal-browser', '~> 0.2'
  s.add_dependency 'opal-rails', '~> 0.9'
  s.add_dependency 'pg', '>= 0.18', '< 2.0'
  s.add_dependency 'rails', '~> 5.2'
  s.add_dependency 'spina', '~> 1.0'

  s.add_development_dependency 'dotenv-rails', '~> 2.5'
  s.add_development_dependency 'mini_racer', '>= 0.2.0'
  s.add_development_dependency 'puma', '~> 3.11'
  s.add_development_dependency 'uglifier', '>= 1.3.0'
  s.add_development_dependency 'web-console', '~> 3.6'
end