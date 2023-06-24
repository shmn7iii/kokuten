# frozen_string_literal: true

class FundsTransaction < ApplicationRecord
  validates :transaction_type, presence: true
  validates :transaction_time, presence: true

  belongs_to :source, polymorphic: true, optional: true
  belongs_to :target, polymorphic: true, optional: true

  enum transaction_type: {
    account_deposit: 0, # 入金
    account_withdrawal: 1, # 出金
    account_transfer: 2, # 口座振替
    wallet_deposit: 3, # ウォレットへチャージ
    wallet_withdrawal: 4, # ウォレットから償還
    wallet_transfer: 5 # ウォレット同士で送金
  }
end
