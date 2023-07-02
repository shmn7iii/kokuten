# frozen_string_literal: true

module Wallets
  class WithdrawalsController < ApplicationController
    before_action :signed_in?

    def new; end

    def create
      Wallets::WithdrawalService.call(user: current_user, amount: withdrawal_params[:amount].to_i)

      redirect_to wallet_path
    end

    private

    def withdrawal_params
      params.require(:withdrawal).permit(:amount)
    end
  end
end
