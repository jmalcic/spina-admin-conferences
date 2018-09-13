Spina::Engine.routes.draw do
  namespace :admin, path: Spina.config.backend_path do
    # TODO fix routing error for conference pages
    namespace :collect do
      resources :conferences
      resources :institutions, except: [:show]
      resources :rooms, except: [:show]
      resources :delegates, except: [:show]
      resources :presentations, except: [:show]
      resources :presentation_types, except: [:show]
      resources :dietary_requirements, except: [:show]
    end
  end
end
