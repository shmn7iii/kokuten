# frozen_string_literal: true

module Admin
  module Users
    class AccountsController < Admin::ApplicationController
      before_action -> { title("User ##{params[:user_id]} Account") }, only: %i[show]
      before_action -> { previous_path(admin_user_path(params[:user_id])) }, only: %i[show]

      def show
        @user = User.find(params[:user_id])
        @account = @user.account
        @account_transactions = @account.account_transactions.order(transaction_time: :DESC)
      end
    end
  end
end
