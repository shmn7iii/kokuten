# frozen_string_literal: true

module Wallets
  class WithdrawalsController < ApplicationController
    before_action :signed_in?

    def new; end

    def create
      Wallets::WithdrawalService.call(account: current_user.account, wallet: current_user.wallet,
                                      amount: withdrawal_params[:amount].to_i)

      redirect_to current_user.wallet
    end

    private

    def withdrawal_params
      params.require(:withdrawal).permit(:amount)
    end
  end
end
