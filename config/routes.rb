# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Spina::Engine.routes.draw do
  namespace :admin, path: Spina.config.backend_path do
    namespace :conferences do
      root to: 'conferences#index'
      resources :conferences, except: [:show] do
        post :import, on: :collection
      end
      resources :institutions, except: [:show] do
        post :import, on: :collection
      end
      resources :rooms, except: [:show] do
        post :import, on: :collection
      end
      resources :delegates, except: [:show] do
        post :import, on: :collection
      end
      resources :presentations, except: [:show] do
        post :import, on: :collection
      end
      resources :presentation_types, except: [:show] do
        post :import, on: :collection
      end
      resources :dietary_requirements, except: [:show] do
        post :import, on: :collection
      end
      resources :presentation_attachment_types, except: [:show]
    end
  end
end

# rubocop:enable Metrics/BlockLength
