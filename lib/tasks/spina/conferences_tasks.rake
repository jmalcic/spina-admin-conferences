# frozen_string_literal: true

namespace :spina_conferences do
  namespace :webpacker do
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
