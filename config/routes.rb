# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'


  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy'

  resource :user, only: %i[show]

  resource :account, only: %i[show] do
    scope module: :accounts do
      resource :deposit, only: %i[new create]
      resource :withdrawal, only: %i[new create]
      resource :transfer, only: %i[new create]
    end
  end

  resource :wallet, only: %i[show new create] do
    scope module: :wallets do
      resource :deposit, only: %i[new create]
      resource :withdrawal, only: %i[new create]
      resource :transfer, only: %i[new create]
    end
  end

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
