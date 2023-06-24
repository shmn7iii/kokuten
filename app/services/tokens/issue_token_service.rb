# frozen_string_literal: true

module Tokens
  class IssueTokenService < BaseService
    def initialize(wallet:, amount:)
      @wallet = wallet
      @amount = amount

      @token = Token.instance
    end

    def call
      ActiveRecord::Base.transaction do
        tx = @token.issue!(wallet: @wallet, amount: @amount)

        TokenTransaction.create!(
          token: @token,
          amount: @amount,
          tapyrus_transaction_payload_hex: tx.to_payload.bth,
          transaction_type: :issue,
          transaction_time: Time.current
        )
      end
    end
  end
end
