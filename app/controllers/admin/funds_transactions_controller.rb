# frozen_string_literal: true

module Admin
  class FundsTransactionsController < Admin::ApplicationController
    before_action -> { title('Funds Transactions') }, only: %i[index]
    before_action -> { title("Funds Transaction ##{params[:id]}") }, only: %i[show]
    before_action -> { previous_path(admin_funds_transactions_path) }, only: %i[show]

    def index
      @funds_transactions = FundsTransaction.all.order(transaction_time: :DESC)
    end

    def show
      @funds_transaction = FundsTransaction.find(params[:id])
      @source_transaction, @source_user = case @funds_transaction.source_type
                                          when 'AccountTransaction'
                                            transaction = AccountTransaction.find(@funds_transaction.source_id)
                                            user = transaction.account.user
                                            [transaction, user]
                                          when 'WalletTransaction'
                                            transaction = WalletTransaction.find(@funds_transaction.source_id)
                                            user = transaction.wallet.user
                                            [transaction, user]
                                          end
      @target_transaction, @target_user = case @funds_transaction.target_type
                                          when 'AccountTransaction'
                                            transaction = AccountTransaction.find(@funds_transaction.target_id)
                                            user = transaction.account.user
                                            [transaction, user]
                                          when 'WalletTransaction'
                                            transaction = WalletTransaction.find(@funds_transaction.target_id)
                                            user = transaction.wallet.user
                                            [transaction, user]
                                          end
    end
  end
end
