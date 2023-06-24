# frozen_string_literal: true

module Accounts
  class DepositService < BaseService
    def initialize(account:, amount:)
      @account = account
      @amount = amount
    end

    def call
      target = AccountTransaction.create!(account: @account, amount: @amount,
                                          transaction_type: :deposit, transaction_time: Time.current)
      @account.update!(balance: @account.balance + @amount)

      FundsTransaction.create!(source: nil, target:, transaction_type: :account_deposit, transaction_time: Time.current)
    end
  end
end
