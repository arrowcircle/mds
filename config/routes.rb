# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  root to: 'welcome#index'
  post :search, as: :search, to: "searches#index"
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
  get 'health_check', to: 'welcome#health_check'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
