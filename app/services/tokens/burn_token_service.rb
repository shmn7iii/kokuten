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
      tx = @token.glueby_token.burn!(sender: @wallet.glueby_wallet, amount: @amount)

      TokenTransaction.create!(token: @token, amount: -@amount, tapyrus_transaction_payload: tx.to_payload,
                               transaction_type: :burn, transaction_time: Time.current)
    end
  end
end
