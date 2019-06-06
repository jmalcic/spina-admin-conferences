# desc "Explaining what the task does"
# task :spina_conferences do
#   # Task goes here
# end

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
