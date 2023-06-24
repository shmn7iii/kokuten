# frozen_string_literal: true

module Accounts
  class AccountTransferService < BaseService
    def initialize(source_account:, target_account:, amount:)
      @source_account = source_account
      @target_account = target_account
      @amount = amount
    end

    def call
      ActiveRecord::Base.transaction do
        @source_account.update!(balance: @source_account.balance - @amount)
        source = AccountTransaction.create!(
          account: @source_account,
          amount: -@amount,
          transaction_type: :transfer, transaction_time: Time.current
        )

        @target_account.update!(balance: @target_account.balance + @amount)
        target = AccountTransaction.create!(
          account: @target_account,
          amount: @amount,
          transaction_type: :transfer,
          transaction_time: Time.current
        )

        FundsTransaction.create!(
          source:,
          target:,
          transaction_type: :account_transfer,
          transaction_time: Time.current
        )
      end
    end
  end
end
