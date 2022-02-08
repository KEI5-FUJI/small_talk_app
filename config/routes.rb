Rails.application.routes.draw do
  get 'sessions/login'
  get 'sessions/logout'
  get 'tasks/index'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/about'
  get 'static_pages/help'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get  '/signup',  to: 'users#new'
  root 'static_pages#home'
  resources :users do
    member do 
      get :following, :followers
    end
  end
  resources :tasks, only: [:index, :show, :create, :destroy]
  resources :account_activations, only: [:edit]
  resources :relationships, only: [:create, :destroy]
end
