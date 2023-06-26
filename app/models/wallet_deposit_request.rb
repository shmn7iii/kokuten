# frozen_string_literal: true

# ウォレット入金リクエスト
# ステータスに応じJobで処理を進める
class WalletDepositRequest < ApplicationRecord
  validates :amount, presence: true
  validates :status, presence: true

  belongs_to :token
  belongs_to :user
  belongs_to :account_transaction
  belongs_to :token_transaction, optional: true
  belongs_to :wallet_transaction, optional: true

  enum status: {
    not_yet_issued: 0, # 発行待ち
    issued_not_yet_finalized: 1, # 発行済み,確定待ち
    not_yet_transferred: 2, # 転送待ち
    transferred_not_yet_finalized: 3, # 転送済み,確定待ち
    completed: 9 # 完了
  }

  scope :not_yet_finalized, -> { where(status: %i[issued_not_yet_finalized transferred_not_yet_finalized]) }
end
