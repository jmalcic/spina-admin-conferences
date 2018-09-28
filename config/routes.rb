# frozen_string_literal: true

Spina::Engine.routes.draw do
  namespace :admin, path: Spina.config.backend_path do
    resources :conference_pages, controller: 'collect/conference_pages'
    namespace :collect do
      root to: 'conferences#index'
      resources :conferences do
        resources :presentation_types, :rooms, except: [:show]
      end
      resources :institutions, except: [:show] do
        resources :rooms, except: [:show]
      end
      resources :rooms, except: [:show] do
        resources :presentations, except: [:show]
      end
      resources :delegates, except: [:show]
      resources :presentations, except: [:show] do
        resources :delegates, except: [:show]
      end
      resources :presentation_types do
        resources :rooms, :presentations, except: [:show]
        resources :room_uses, only: [:index]
      end
      resources :dietary_requirements, except: [:show]
    end
  end
end
