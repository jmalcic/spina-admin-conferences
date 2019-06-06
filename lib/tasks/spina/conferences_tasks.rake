# frozen_string_literal: true

namespace :spina_conferences do
  namespace :webpacker do
    desc 'Compile JavaScript packs using webpack for production with digests'
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

Rake::Task[:'app:assets:precompile'].enhance [:'spina_conferences:webpacker:compile']
