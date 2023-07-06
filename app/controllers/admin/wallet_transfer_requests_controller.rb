# frozen_string_literal: true

module Admin
  class WalletTransferRequestsController < Admin::ApplicationController
    before_action -> { title('Wallet Transfer Requests') }, only: %i[index]

    def index
      @wallet_transfer_requests = WalletTransferRequest.all.order(created_at: :DESC)
    end
  end
end
