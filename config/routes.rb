Rails.application.routes.draw do
  get 'tasks/index'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/about'
  get 'static_pages/help'
  root 'static_pages#home'
  resources :tasks, only: [:index, :create, :destroy]
end
