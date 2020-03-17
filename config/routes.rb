require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  resources :merchants, only: %i[index edit update]

  namespace :api do
    namespace :v1 do
      post :login, to: 'authentication#login'

      resource :payments, only: :create
    end
  end

  root to: 'merchants#index'
end
