# frozen_string_literal: true

class CreateAccountTransferTransactionService < BaseService
  def initialize(source_account:, target_account:, amount:)
    @source_account = source_account
    @target_account = target_account
    @amount = amount
  end

  def call
    transaction_time = Time.current

    source_transaction = AccountTransaction.create!(account: @source_account, amount: -@amount,
                                                    transaction_type: :transfer, transaction_time:)
    @source_account.update!(balance: @source_account.balance - @amount)

    target_transaction = AccountTransaction.create!(account: @target_account, amount: @amount,
                                                    transaction_type: :transfer, transaction_time:)
    @target_account.update!(balance: @target_account.balance + @amount)

    AccountTransferTransaction.create!(source: source_transaction, target: target_transaction, transaction_time:)
  end
end
