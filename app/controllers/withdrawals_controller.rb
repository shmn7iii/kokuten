# frozen_string_literal: true

class WithdrawalsController < ApplicationController
  before_action :signed_in?

  def new; end

  def create
    WithdrawalService.call(account: current_user.account, amount: withdrawal_params[:amount].to_i)

    redirect_to current_user.account
  end

  private

  def withdrawal_params
    params.require(:withdrawal).permit(:amount)
  end
end
