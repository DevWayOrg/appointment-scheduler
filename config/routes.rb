Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'register', to: 'sessions#new', as: 'register'

  root 'sessions#new'

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  get '/auth/:provider/callback', to: 'sessions#create', as: 'auth_callback'

  resources :appointments, only: %i[create]

  # Defines the root path route ("/")
  # root "posts#index"
end
