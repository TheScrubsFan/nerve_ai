Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users

  root to: 'games#new'

  resources :users  do
    collection do
      get :current
    end
  end

  resources :games, only: [:new, :create, :show] do
    member do
      post :make_step
    end
  end
end
