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
  delete 'logout', to: 'sessions#logout'
  root 'static_pages#home'
  resources :users
  resources :tasks, only: [:index, :show, :create, :destroy]
end
