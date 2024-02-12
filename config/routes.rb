# frozen_string_literal: true

Rails.application.routes.draw do
  require "sidekiq/web"
  require "sidekiq/cron/web"
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  passwordless_for :users
  root to: "welcome#index"
  resources :artists do
    get :search, on: :collection
    resources :tracks do
      get :search, on: :collection
    end
  end
  resources :authors do
    resources :stories do
      patch :play, on: :member
      resources :playlists
    end
  end
  resource :player, only: %i[create update destroy]
  resource :profile, only: %i[show update]
  post :search, as: :search, to: "searches#index"
  resources :users, only: %i[index show new create]
  get "/proxy/*url", as: :proxy, to: "proxy#show" unless Rails.env.production?
  get "health_check", to: "welcome#health_check"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
