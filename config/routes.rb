# frozen_string_literal: true

Spina::Engine.routes.draw do
  namespace :admin, path: Spina.config.backend_path do
    resources :conference_pages, controller: 'collect/conference_pages'
    namespace :collect do
      root to: 'conferences#index'

      resources :conferences
      resources :institutions, except: [:show]
      resources :rooms, except: [:show]
      resources :delegates, except: [:show]
      resources :presentations, except: [:show]
      resources :presentation_types
      resources :dietary_requirements, except: [:show]
    end
  end
end
