# frozen_string_literal: true

# 口座の入出金を管理するモデル
class AccountTransaction < ApplicationRecord
  validates :amount, presence: true
  validates :transaction_type, presence: true
  validates :transaction_time, presence: true

  belongs_to :account
  has_one :funds_transaction, as: :source
  has_one :funds_transaction, as: :target

  enum transaction_type: {
    deposit: 0, # 入金
    withdrawal: 1, # 出金
    transfer: 2 # 口座振替
  }

  def description
    case transaction_type
    when 'deposit'
      '入金'
    when 'withdrawal'
      '出金'
    when 'transfer'
      '口座振替'
    else
      raise NotImplementedError
    end
  end
end
