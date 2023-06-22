# frozen_string_literal: true

module Tokens
  class IssueTokenService < BaseService
    TOKEN_PAYLOAD = 'HOGE' # TODO: .envにでも書きたい

    def initialize(wallet:, amount:)
      @wallet = wallet
      @amount = amount

      @token = Token.find_by(payload: TOKEN_PAYLOAD)
    end

    def call
      _, tx = @token.glueby_token.reissue!(issuer: @wallet.glueby_wallet, amount: @amount)

      TokenTransaction.create!(token: @token, amount: @amount, tapyrus_transaction_payload: tx.to_payload,
                                 transaction_type: :issue, transaction_time: Time.current)
    end
  end
end
