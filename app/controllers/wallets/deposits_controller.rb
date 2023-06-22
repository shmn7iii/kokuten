# frozen_string_literal: true

module Wallets
  class DepositsController < ApplicationController
    before_action :signed_in?

    def new; end

    def create
      Wallets::DepositService.call(account: current_user.account, wallet: current_user.wallet,
                                   amount: deposit_params[:amount].to_i)

      redirect_to current_user.wallet
    end

    private

    def deposit_params
      params.require(:deposit).permit(:amount)
    end
  end
end
