# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  post 'signup/callback', to: 'users#callback'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'login/callback', to: 'sessions#callback'

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

  namespace :admin do
    resource :dashboard, only: %i[show]
    resources :funds_transactions, only: %i[index show]
    resources :token_transactions, only: %i[index]
    resource :utxo_provider, only: %i[show]

    resources :users, only: %i[index show] do
      scope module: :users do
        resource :account, only: %i[show]
        resource :wallet, only: %i[show]
      end
    end

    resources :wallet_deposit_requests, only: %i[index]
    resources :wallet_transfer_requests, only: %i[index]
    resources :wallet_withdrawal_requests, only: %i[index]
  end

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
