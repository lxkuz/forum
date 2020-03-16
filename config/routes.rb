Rails.application.routes.draw do
  devise_for :users

  resources :merchants, only: [:index, :edit, :update]

  namespace :api do
    namespace :v1 do
      post :login, to: 'authentication#login'

      resource :payments, only: :create
    end
  end

  root to: 'merchants#index'
end
