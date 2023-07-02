# frozen_string_literal: true

module Wallets
  class DepositsController < ApplicationController
    before_action :signed_in?

    def new; end

    def create
      Wallets::DepositService.call(user: current_user, amount: deposit_params[:amount].to_i)

      redirect_to wallet_path
    end

    private

    def deposit_params
      params.require(:deposit).permit(:amount)
    end
  end
end
