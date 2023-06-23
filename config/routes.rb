# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resource :session, only: %i[new create destroy]
  resource :user, only: %i[show new create]
  resource :account, only: %i[show]
  resource :deposit, only: %i[new create]
  resource :withdrawal, only: %i[new create]
  resource :account_transfer, only: %i[new create]

  namespace :admin do
    root to: 'users#index'
    resources :users
    resources :account_transfer_transactions
    resources :account_transactions
    resources :accounts
  end
end
