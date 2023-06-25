# frozen_string_literal: true

module Wallets
  class DepositService < BaseService
    def initialize(user:, amount:)
      @user = user
      @amount = amount

      @token = Token.instance
    end

    def call
      # TODO: 残高不足の回避
      # return しなきゃいけない && 非同期なのであらかじめ残高確保したい

      ActiveRecord::Base.transaction do
        account = @user.account

        account.update!(balance: account.balance - @amount)
        account_transaction = AccountTransaction.create!(
          account:,
          amount: -@amount,
          transaction_type: :transfer,
          transaction_time: Time.current
        )

        WalletDepositRequest.create!(
          token: @token,
          user: @user,
          account_transaction:,
          amount: @amount,
          status: :not_yet_issued
        )
      end
    end
  end
end
