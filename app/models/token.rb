# frozen_string_literal: true

class Token < ApplicationRecord
  validates :payload, presence: true

  has_many :token_transactions

  def amount(wallet:)
    glueby_token.amount(wallet:)
  end

  def issue!(wallet:, amount:)
    glueby_token.reissue!(issuer: wallet.glueby_wallet, amount:)
    glueby_token.amount(wallet:)
  end

  def burn!(wallet:, amount:)
    glueby_token.reissue!(issuer: wallet.glueby_wallet, amount:)
    glueby_token.amount(wallet:)
  end

  def glueby_token
    @glueby_token ||= Glueby::Contract::Token.parse_from_payload(payload)
  end
end