# frozen_string_literal: true

Rails.application.routes.draw do
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
      resources :playlists
    end
  end
  resource :profile, only: [:show, :update]
  post :search, as: :search, to: "searches#index"
  resources :users, only: [:index, :show, :new, :create]
  get "health_check", to: "welcome#health_check"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
