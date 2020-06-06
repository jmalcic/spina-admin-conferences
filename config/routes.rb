# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

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
        get :attach, on: :new
        get :attach, on: :member
      end
      resources :presentation_types, except: [:show]
      resources :dietary_requirements, except: [:show]
      resources :presentation_attachment_types, except: [:show]
    end
  end
end

# rubocop:enable Metrics/BlockLength
