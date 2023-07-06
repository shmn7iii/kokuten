# frozen_string_literal: true

module Admin
  class TokenTransactionsController < Admin::ApplicationController
    before_action -> { title('Token Transactions') }, only: %i[index]

    def index
      @token_transactions = TokenTransaction.all.order(transaction_time: :DESC)
    end
  end
end
