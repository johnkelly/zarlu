Zarlu::Application.routes.draw do
  root to: "homes#index"
  match '/pricing', to: 'homes#pricing'
  match '/home', to: 'homes#show'
  devise_for :users, controllers: { registrations: 'registrations' }
  resource 'subscribers', only: %w[show] do
    collection { post :add_user }
  end
end
