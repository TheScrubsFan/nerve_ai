Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users

  root to: 'games#new'

  get 'app', to: 'games#new'

  resources :games, only: [:new, :create]
end
