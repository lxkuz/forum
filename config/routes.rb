Rails.application.routes.draw do
  devise_for :users

  resources :merchants, only: :index

  root to: 'merchants#index'
end
