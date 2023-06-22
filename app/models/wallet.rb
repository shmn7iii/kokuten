# frozen_string_literal: true

class Wallet < ApplicationRecord
  validates :glueby_wallet_id, presence: true

  belongs_to :user
  has_many :wallet_transactions

  def balance
    # TODO: maybe not first
    Token.first.balance(wallet: self)
  end

  def pay_to(wallet:); end

  def glueby_wallet
    @glueby_wallet ||= Glueby::Wallet.load(glueby_wallet_id)
  end
end
