# frozen_string_literal: true

# ウォレット出金リクエスト
# ステータスに応じJobで処理を進める
class WalletWithdrawalRequest < ApplicationRecord
  validates :amount, presence: true
  validates :status, presence: true

  belongs_to :token
  belongs_to :user
  belongs_to :account_transaction, optional: true
  belongs_to :token_transaction, optional: true
  belongs_to :wallet_transaction, optional: true

  enum status: {
    not_yet_burned: 0, # 焼却待ち
    burned_not_yet_finalized: 1, # 焼却済み,確定待ち
    completed: 9 # 完了
  }

  scope :not_yet_finalized, -> { where(status: %i[burned_not_yet_finalized]) }
end
