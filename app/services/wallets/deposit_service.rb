# frozen_string_literal: true

module Wallets
  class DepositService < BaseService
    def initialize(account:, wallet:, amount:)
      @account = account
      @wallet = wallet
      @amount = amount
    end

    def call
      source = AccountTransaction.create!(account: @account, amount: -@amount,
                                          transaction_type: :transfer, transaction_time: Time.current)
      @account.update!(balance: @account.balance - @amount)

      token_transaction = Tokens::IssueTokenService.call(wallet: @wallet, amount: @amount)
      target = WalletTransaction.create!(wallet: @wallet, amount: @amount, token_transaction:,
                                         transaction_type: :deposit, transaction_time: Time.current)

      FundsTransaction.create!(source:, target:, transaction_type: :wallet_deposit, transaction_time: Time.current)
    end
  end
end
