# frozen_string_literal: true

class TokenTransaction < ApplicationRecord
  validates :amount, presence: true
  validates :transaction_type, presence: true
  validates :transaction_time, presence: true

  belongs_to :token
  has_one :funds_transaction, as: :source
  has_one :funds_transaction, as: :target

  enum transaction_type: {
    issue: 0, # 発行
    burn: 1 # 焼却
  }
end
