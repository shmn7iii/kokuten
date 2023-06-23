# frozen_string_literal: true

class Wallet < ApplicationRecord
  validates :glueby_wallet_id, presence: true

  belongs_to :user
  has_many :wallet_transactions

  def load
    Glueby::Wallet.load(glueby_wallet_id)
  end

  # TODO: 任意のトークンのバランスのみ取得
  # def balance
  #  load.balances.
  # end
end
