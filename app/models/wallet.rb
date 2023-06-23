# frozen_string_literal: true

class Wallet < ApplicationRecord
  validates :glueby_wallet_id, presence: true

  belongs_to :user
  has_many :wallet_transactions

  after_initialize do
    self.glueby_wallet_id ||= Glueby::Wallet.create.id
  end

  def balance
    Token.instance.amount(wallet: glueby_wallet)
  end

  def pay_to(wallet:); end

  def glueby_wallet
    @glueby_wallet ||= Glueby::Wallet.load(glueby_wallet_id)
  end
end
