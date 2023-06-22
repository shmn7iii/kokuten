# frozen_string_literal: true

module Tokens
  class BurnTokenService < BaseService
    TOKEN_PAYLOAD = 'HOGE'

    def initialize(wallet:, amount:)
      @wallet = wallet
      @amount = amount

      @token = Token.find_by(payload: TOKEN_PAYLOAD)
    end

    def call
      @token.burn!(wallet: @wallet, amount: @amount)

      transaction_time = Time.current
      source = WalletTransaction.create!(wallet: @wallet, amount: -@amount, transaction_type: :deposit,
                                         transaction_time:)
      target = TokenTransaction.create!(token: @token, amount: @amount, transaction_type: :issue, transaction_time:) # 正負反転
      FundsTransaction.create!(source:, target:, transaction_type: :wallet_deposit, transaction_time:)
    end
  end
end
