# frozen_string_literal: true

module Accounts
  class DepositService < BaseService
    # @param [Account] account
    # @param [Integer] amount
    def initialize(account:, amount:)
      @account = account
      @amount = amount
    end

    def call
      ActiveRecord::Base.transaction do
        @account.update!(balance: @account.balance + @amount)
        target = AccountTransaction.create!(
          account: @account,
          amount: @amount,
          transaction_type: :deposit,
          transaction_time: Time.current
        )

        FundsTransaction.create!(
          source: nil,
          target:,
          transaction_type: :account_deposit,
          transaction_time: Time.current
        )
      end
    end
  end
end
