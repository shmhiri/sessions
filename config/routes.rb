Rails.application.routes.draw do
  resources :sessions
  get 'sessions/index'
  get 'pages/meetings'
  root to: 'pages#home'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
