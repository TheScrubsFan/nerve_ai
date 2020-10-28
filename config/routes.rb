Rails.application.routes.draw do
  devise_for :users

  root to: 'games#new'

  get 'app', to: 'games#new'

  resources :games, only: :new
end
