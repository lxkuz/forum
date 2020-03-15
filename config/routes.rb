Rails.application.routes.draw do
  devise_for :users

  resources :merchants, only: :index

  namespace :api do
    namespace :v1 do
      resource :payments, only: :create
    end
  end

  root to: 'merchants#index'
end
