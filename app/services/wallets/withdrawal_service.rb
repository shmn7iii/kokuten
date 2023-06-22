# frozen_string_literal: true

module Wallets
  class WithdrawalService < BaseService
    def initialize(account:, wallet:, amount:)
      @account = account
      @wallet = wallet
      @amount = amount
    end

    def call
      transaction_time = Time.current

      token_transaction = Tokens::BurnTokenService.call(wallet: @wallet, amount: @amount)
      source = WalletTransaction.create!(wallet: @wallet, amount: -@amount, token_transaction:,
                                         transaction_type: :withdrawal, transaction_time:)
      target = AccountTransaction.create!(account: @account, amount: @amount,
                                          transaction_type: :transfer, transaction_time:)
      @account.update!(balance: @account.balance + @amount)

      FundsTransaction.create!(source:, target:, transaction_type: :wallet_deposit, transaction_time:)
    end
  end
end
