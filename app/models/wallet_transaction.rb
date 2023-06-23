# frozen_string_literal: true

class WalletTransaction < ApplicationRecord
  validates :amount, presence: true
  validates :transaction_type, presence: true
  validates :transaction_time, presence: true

  belongs_to :wallet
  belongs_to :token_transaction
  has_one :funds_transaction, as: :source
  has_one :funds_transaction, as: :target

  enum transaction_type: {
    deposit: 0, # 入金
    withdrawal: 1, # 出金
    transfer: 2 # 送金
  }
end
