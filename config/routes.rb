Spina::Engine.routes.draw do
  namespace :collect do
    resources :conferences, only: [:index, :show]
    resources :presentations, only: [:index, :show]
  end
  namespace :admin, path: Spina.config.backend_path do
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
