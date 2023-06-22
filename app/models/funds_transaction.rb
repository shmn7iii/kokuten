# frozen_string_literal: true

class FundsTransaction < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true

  # これ行ける?
  has_one :funds_transaction, as: :source
  has_one :funds_transaction, as: :target

  enum transaction_type: {
    account_deposit: 0, # 入金
    account_withdrawal: 1, # 出金
    account_transfer: 2, # 口座振替
    wallet_deposit: 3, # ウォレットへチャージ
    wallet_withdrawal: 4, # ウォレットから償還
    wallet_transfer: 5 # ウォレット同士で送金
  }
end
