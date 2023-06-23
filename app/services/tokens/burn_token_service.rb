# frozen_string_literal: true

module Tokens
  class BurnTokenService < BaseService
    def initialize(wallet:, amount:)
      @wallet = wallet
      @amount = amount

      @token = Token.instance
    end

    def call
      tx = @token.burn!(wallet: @wallet, amount: @amount)

      TokenTransaction.create!(token: @token, amount: -@amount, tapyrus_transaction_payload_hex: tx.to_payload.bth,
                               transaction_type: :burn, transaction_time: Time.current)
    end
  end
end
