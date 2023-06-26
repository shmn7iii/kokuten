# frozen_string_literal: true

# ウォレットの入出金を管理するモデル
class WalletTransaction < ApplicationRecord
  validates :amount, presence: true
  validates :transaction_type, presence: true
  validates :transaction_time, presence: true

  belongs_to :wallet
  has_one :funds_transaction, as: :source
  has_one :funds_transaction, as: :target

  enum transaction_type: {
    deposit: 0, # 入金
    withdrawal: 1, # 出金
    transfer: 2 # 送金
  }

  def description
    case transaction_type
    when 'deposit'
      '入金'
    when 'withdrawal'
      '出金'
    when 'transfer'
      '送金'
    else
      raise NotImplementedError
    end
  end
end
