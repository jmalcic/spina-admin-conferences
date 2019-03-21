# frozen_string_literal: true

Spina::Engine.routes.draw do
  namespace :admin, path: Spina.config.backend_path do
    resources :conference_pages, controller: 'conferences/conference_pages'
    namespace :conferences do
      root to: 'conferences#index'
      resources :conferences do
        resources :presentation_types, only: [:index]
      end
      resources :institutions, except: [:show]
      resources :rooms, except: [:show]
      resources :delegates, except: [:show]
      resources :presentations, except: [:show] do
        post :import, on: :collection
      end
      resources :presentation_types do
        resources :room_uses, only: [:index]
      end
      resources :dietary_requirements, except: [:show]
    end
  end
end
