Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'messages/create'
  get 'sessions/login'
  get 'sessions/logout'
  get 'tasks/index'
  get 'static_pages/home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get  '/signup',  to: 'users#new'
  get '/search', to: 'searches#search'
  root 'static_pages#home'
  resources :users
  resources :tasks, only: [:index, :show, :create, :destroy] do
    resources :messagerooms, only: [:show, :create, :destroy, :index] do
      resources :messages, only: [:create] do
      end
    end
  end
  resources :account_activations, only: [:edit]
  resources :relationships, only: [:create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
