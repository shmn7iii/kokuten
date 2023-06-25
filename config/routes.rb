# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resource :session, only: %i[new create destroy]
  resource :user, only: %i[show new create]

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
