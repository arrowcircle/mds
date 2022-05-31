# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  root to: 'welcome#index'
  post :search, as: :search, to: "searches#index"

  resources :authors do
  end
  get 'health_check', to: 'welcome#health_check'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
