# frozen_string_literal: true

module Admin
  class DashboardsController < Admin::ApplicationController
    before_action -> { title('Dashboard') }, only: %i[show]

    def show
      @total_amount_of_token = Token.instance.total_amount
      @user_count = User.count
      # -1 は UTXO Provider
      @wallet_count = Wallet.count - 1
    end
  end
end
