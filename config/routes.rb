Spina::Engine.routes.draw do
  namespace :admin, path: Spina.config.backend_path do
    resources :conferences
    resources :delegates, except: [:show]
    resources :presentations, except: [:show]
    resources :presentation_types, except: [:show]
    resources :dietary_requirements, except: [:show]
  end

  namespace :collect do
    resources :presentations, only: [:index, :show]
  end
end
