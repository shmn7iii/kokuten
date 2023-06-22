# frozen_string_literal: true

module Accounts
  class WithdrawalService < BaseService
    def initialize(account:, amount:)
      @account = account
      @amount = amount
    end

    def call
      AccountTransaction.create!(account: @account, amount: -@amount,
                                 transaction_type: :withdrawal, transaction_time: Time.current)

      @account.update!(balance: @account.balance - @amount)
    end
  end
end
