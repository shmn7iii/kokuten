# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :signed_in?, only: %i[show]

  def show
    @account = current_user.account
    @account_transactions = @account.account_transactions.order(transaction_time: :DESC)
  end
end
