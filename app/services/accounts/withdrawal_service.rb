# frozen_string_literal: true

module Accounts
  class WithdrawalService < BaseService
    def initialize(account:, amount:)
      @account = account
      @amount = amount
    end

    def call
      ActiveRecord::Base.transaction do
        @account.update!(balance: @account.balance - @amount)
        source = AccountTransaction.create!(
          account: @account,
          amount: -@amount,
          transaction_type: :withdrawal,
          transaction_time: Time.current
        )

        FundsTransaction.create!(source:,
                                 target: nil,
                                 transaction_type: :account_withdrawal,
                                 transaction_time: Time.current)
      end
    end
  end
end
