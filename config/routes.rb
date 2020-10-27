Rails.application.routes.draw do
  root to: 'games#new'

  get 'app', to: 'games#new'

  resources :games, only: :new
end
