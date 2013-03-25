require 'sidekiq/web'

Zarlu::Application.routes.draw do
  root to: "homes#index"
  match 'blog' => 'blog#index'
  match 'blog/:title' => 'blog#post'
  match '/atom.xml' => 'blog#atom', as: :feed, defaults: { format: 'xml' }
  match '/pricing', to: 'homes#pricing'
  match '/home', to: 'homes#show'
  match '/welcome', to: 'welcomes#show'
  devise_for :users, controllers: { registrations: 'registrations' }
  resource :subscribers, only: %w[show] do
    collection { post :add_user }
    member do
      put :change_manager
      put :promote_to_manager
    end
  end
  resources :events, only: %w[index create update destroy]
  resources :incoming_mails, only: %w[create]
  resources :employees, only: %w[index update]
  resources :schedules, only: %w[show]
  resource :subscriptions, only: %w[update show]
  resources :activities, only: %w[index]
  resources :welcomes, only: %w[create]
  mount Sidekiq::Web => '/sidekiq'
end
