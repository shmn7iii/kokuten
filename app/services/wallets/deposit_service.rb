# frozen_string_literal: true

module Wallets
  class DepositService < BaseService
    def initialize(account:, wallet:, amount:)
      @account = account
      @wallet = wallet
      @amount = amount
    end

    def call
      transaction_time = Time.current

      source = AccountTransaction.create!(account: @account, amount: -@amount,
                                          transaction_type: :transfer, transaction_time:)
      @account.update!(balance: @account.balance - @amount)

      token_transaction = Tokens::IssueTokenService.call(wallet: @wallet, amount: @amount)
      target = WalletTransaction.create!(wallet: @wallet, amount: @amount, token_transaction:,
                                         transaction_type: :deposit, transaction_time:)

      FundsTransaction.create!(source:, target:, transaction_type: :wallet_deposit, transaction_time:)
    end
  end
end
