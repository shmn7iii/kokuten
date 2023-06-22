# frozen_string_literal: true

module Accounts
  class TransfersController < ApplicationController
    before_action :signed_in?

    def new; end

    def create
      target_account = Account.find_by(account_number: account_transfer_params[:target_account_number])
      Accounts::AccountTransferService.call(source_account: current_user.account, target_account:,
                                            amount: account_transfer_params[:amount].to_i)

      redirect_to current_user.account
    end

    private

    def account_transfer_params
      params.require(:account_transfer).permit(:target_account_number, :amount)
    end
  end
end
