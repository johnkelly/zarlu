Zarlu::Application.routes.draw do
  root to: "homes#index"
  match '/pricing', to: 'homes#pricing'
  devise_for :users, controllers: { registrations: 'registrations' }
  resource 'subscribers', only: %w[show]
end
