# frozen_string_literal: true

module Accounts
  class DepositsController < ApplicationController
    before_action :signed_in?

    def new; end

    def create
      Accounts::DepositService.call(account: current_user.account, amount: deposit_params[:amount].to_i)

      redirect_to current_user.account
    end

    private

    def deposit_params
      params.require(:deposit).permit(:amount)
    end
  end
end
