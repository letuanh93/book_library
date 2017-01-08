Rails.application.routes.draw do
  resources :books
  resources :likes, only: [:create, :destroy]
  resources :requests
  resources :categories
  resources :reviews
  resources :comments
  resources :authors
  resources :publishers
  resources :users
  resources :relationships, only: [:create, :destroy]
  resources :followers, only: [:index]
  resources :following, only: [:index]
  root "static_pages#home"
  namespace :admin do
    resources :categories
    resources :authors
    resources :publishers
    resources :books
    resources :requests
    resources :users
  end
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  delete "/logout", to: "sessions#destroy"
end
