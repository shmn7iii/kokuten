# frozen_string_literal: true

module Accounts
  class WithdrawalService < BaseService
    def initialize(account:, amount:)
      @account = account
      @amount = amount
    end

    def call
      source = AccountTransaction.create!(account: @account, amount: -@amount,
                                          transaction_type: :withdrawal, transaction_time: Time.current)
      @account.update!(balance: @account.balance - @amount)

      FundsTransaction.create!(source:, target: nil, transaction_type: :account_withdrawal,
                               transaction_time: Time.current)
    end
  end
end
