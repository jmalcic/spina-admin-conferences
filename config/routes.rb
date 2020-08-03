# frozen_string_literal: true

Spina::Engine.routes.draw do
  namespace :admin, path: Spina.config.backend_path do
    namespace :conferences do
      root to: 'conferences#index'
      resources :conferences, except: [:show]
      resources :institutions, except: [:show]
      resources :rooms, except: [:show]
      resources :sessions, except: [:show]
      resources :delegates, except: [:show] do
        post :import, on: :collection
      end
      resources :presentations, except: [:show] do
        post :import, on: :collection
        resources :presentation_attachments, only: [:new]
      end
      resources :presentation_attachments, only: [:new]
      resources :presentation_types, except: [:show]
      resources :dietary_requirements, except: [:show]
      resources :presentation_attachment_types, except: [:show]
    end
  end
end
