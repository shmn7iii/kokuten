# frozen_string_literal: true

module Wallets
  class TransfersController < ApplicationController
    before_action :signed_in?

    def new; end

    def create
      receiver = User.find_by(username: wallet_transfer_params[:receiver_username])
      Wallets::TransferService.call(sender: current_user, receiver:,
                                    amount: wallet_transfer_params[:amount].to_i)

      redirect_to current_user.wallet
    end

    private

    def wallet_transfer_params
      params.require(:wallet_transfer).permit(:receiver_username, :amount)
    end
  end
end
