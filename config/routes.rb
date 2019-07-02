# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Spina::Engine.routes.draw do
  namespace :conferences, path: 'conferences' do
    resources :presentations, only: [:show]
    resources :conferences, only: %i[index show]
  end
  namespace :admin, path: Spina.config.backend_path do
    resources :conference_pages, controller: 'conferences/conference_pages'
    namespace :conferences do
      root to: 'conferences#index'
      resources :conferences do
        post :import, on: :collection
        resources :presentation_types, only: [:index]
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
      resources :presentation_types do
        post :import, on: :collection
        resources :room_uses, only: [:index]
      end
      resources :dietary_requirements, except: [:show] do
        post :import, on: :collection
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
