# frozen_string_literal: true

module Tokens
  class IssueTokenService < BaseService
    TOKEN_PAYLOAD = 'HOGE'

    def initialize(wallet:, amount:)
      @wallet = wallet
      @amount = amount

      @token = Token.find_by(payload: TOKEN_PAYLOAD)
    end

    def call
      @token.issue!(wallet: @wallet, amount: @amount)

      transaction_time = Time.current
      source = TokenTransaction.create!(token: @token, amount: -@amount, transaction_type: :issue, transaction_time:) # 正負反転
      target = WalletTransaction.create!(wallet: @wallet, amount: @amount, transaction_type: :deposit,
                                         transaction_time:)
      FundsTransaction.create!(source:, target:, transaction_type: :wallet_deposit, transaction_time:)
    end
  end
end
