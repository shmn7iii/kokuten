# frozen_string_literal: true

class TokenTransaction < ApplicationRecord
  validates :amount, presence: true
  validates :tapyrus_transaction_payload, presence: true
  validates :transaction_type, presence: true
  validates :transaction_time, presence: true

  belongs_to :token
  has_one :wallet_transaction

  enum transaction_type: {
    issue: 0, # 発行
    burn: 1 # 焼却
  }
end
