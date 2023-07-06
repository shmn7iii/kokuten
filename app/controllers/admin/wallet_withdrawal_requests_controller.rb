# frozen_string_literal: true

module Admin
  class WalletWithdrawalRequestsController < Admin::ApplicationController
    before_action -> { title('Wallet Withdrawal Requests') }, only: %i[index]

    def index
      @wallet_withdrawal_requests = WalletWithdrawalRequest.all.order(created_at: :DESC)
    end
  end
end
