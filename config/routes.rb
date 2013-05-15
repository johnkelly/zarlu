require 'sidekiq/web'

Zarlu::Application.routes.draw do
  root to: "homes#index"
  get 'blog' => 'blog#index'
  get 'blog/:title' => 'blog#post'
  get '/atom.xml' => 'blog#atom', as: :feed, defaults: { format: 'xml' }
  get '/pricing', to: 'homes#pricing'
  get '/home', to: 'homes#show'
  get '/privacy-policy', to: 'homes#privacy'
  get '/welcome', to: 'welcomes#show'
  get '/employee-leave-management', to: 'articles#employee_leave_management'
  get '/employee-attendance-calendar', to: 'articles#employee_attendance_calendar'
  get '/business-time-tracking', to: 'articles#business_time_tracking'
  devise_for :users, controllers: { registrations: 'registrations' }
  resource :subscribers, only: %w[update show] do
    collection { post :add_user }
    member do
      put :change_manager
      put :promote_to_manager
      put :demote_to_employee
    end
  end
  resources :events, only: %w[index create update destroy] do
    collection do
      get :manager
      get :company
    end
  end
  resource :leaves, only: %w[show]
  resources :incoming_mails, only: %w[create]
  resources :employees, only: %w[index update show]
  resource :subscriptions, only: %w[update show]
  resources :activities, only: %w[index]
  resources :welcomes, only: %w[create]
  resources :company_settings, only: %w[index update]
  resources :accrued_hours, only: %w[update]
  mount Sidekiq::Web => '/sidekiq'
end
