# frozen_string_literal: true

module Admin
  class WalletDepositRequestsController < Admin::ApplicationController
    before_action -> { title('Wallet Deposit Requests') }, only: %i[index]

    def index
      @wallet_deposit_requests = WalletDepositRequest.all.order(created_at: :DESC)
    end
  end
end
