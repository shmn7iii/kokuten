# frozen_string_literal: true

class DepositService < BaseService
  def initialize(account:, amount:)
    @account = account
    @amount = amount
  end

  def call
    AccountTransaction.create!(account: @account,
                               amount: @amount,
                               transaction_type: :deposit,
                               transaction_time: Time.current)

    @account.update!(balance: @account.balance + @amount)
  end
end
