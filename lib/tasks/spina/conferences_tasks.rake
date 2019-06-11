# frozen_string_literal: true

def yarn_install_available?
  rails_major = Rails::VERSION::MAJOR
  rails_minor = Rails::VERSION::MINOR

  rails_major > 5 || (rails_major == 5 && rails_minor >= 1)
end

def enhance_assets_precompile
  # yarn:install was added in Rails 5.1
  deps = yarn_install_available? ? [] : ['spina_conferences:webpacker:yarn_install']
  webpack_compilation_task = Rake::Task['spina_conferences:webpacker:compile']
  Rake::Task['assets:precompile'].enhance(deps) do
    webpack_compilation_task.invoke
  end
end

namespace :spina_conferences do
  namespace :webpacker do
    task :yarn_install do
      system 'yarn install --no-progress'
    end

    task compile: %i[environment] do
      Webpacker.with_node_env('production') do
        if Spina::Conferences::Engine.webpacker.commands.compile
          # Successful compilation!
        else
          # Failed compilation
          exit!
        end
      end
    end
  end
end

# Compile packs after we've compiled all other assets during precompilation
skip_webpacker_precompile = %w[no false n f].include?(ENV['WEBPACKER_PRECOMPILE'])

unless skip_webpacker_precompile
  if Rake::Task.task_defined?('assets:precompile')
    enhance_assets_precompile
  else
    Rake::Task.define_task('assets:precompile':
                             %w[spina_conferences:webpacker:yarn_install spina_conferences:webpacker:compile])
  end
end
