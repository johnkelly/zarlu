require 'sidekiq/web'

Zarlu::Application.routes.draw do
  root to: "homes#index"
  get 'blog' => 'blog#index'
  get 'blog/:title' => 'blog#post'
  get '/atom.xml' => 'blog#atom', as: :feed, defaults: { format: 'xml' }
  get '/pricing', to: 'homes#pricing'
  get '/home', to: 'homes#show'
  get '/privacy-policy', to: 'homes#privacy'
  get '/features', to: 'homes#features'
  get '/terms-of-service', to: 'homes#terms_of_service'
  get '/employee-welcome', to: 'employee_welcomes#show', as: "employee_welcome"
  get '/employee-leave-management', to: 'articles#employee_leave_management'
  get '/employee-attendance-calendar', to: 'articles#employee_attendance_calendar'
  get '/business-time-tracking', to: 'articles#business_time_tracking'
  get '/manager/setup-employees', to: 'employees#new', as: 'manager_setup_employees'
  get '/manager/setup-data', to: 'import_attendance#new', as: 'manager_setup_data'
  get '/manager/setup-complete', to: 'welcomes#show', as: 'manager_setup_complete'
  devise_for :users, controllers: { registrations: 'registrations' }, skip: 'invitation'
  devise_scope :user do
    get "/users/invitation/accept", :to => "devise/invitations#edit",   :as => 'accept_user_invitation'
    put "/users/invitation/:id",        :to => "devise/invitations#update", :as => nil
    patch "/users/invitation/:id",        :to => "devise/invitations#update", :as => nil
  end
  resource :subscribers, only: %w[update show] do
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
  resources :employees, only: %w[index create update show]
  resource :subscriptions, only: %w[update show]
  resources :activities, only: %w[index]
  resources :welcomes, only: %w[create]
  resources :company_settings, only: %w[index update]
  resources :accruals, only: %w[create destroy]
  resources :holidays, only: %w[index create destroy]
  resources :accrued_hours, only: %w[update]
  resources :import_attendance, only: %w[create]
  namespace :subscriber do
    resources :users, only: %w[create update destroy]
  end
  mount Sidekiq::Web => '/sidekiq'
end
