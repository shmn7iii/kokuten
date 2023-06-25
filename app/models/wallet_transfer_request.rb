# frozen_string_literal: true

class WalletTransferRequest < ApplicationRecord
  validates :amount, presence: true
  validates :status, presence: true

  belongs_to :token
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :funds_transaction, optional: true

  enum status: {
    not_yet_transferred: 0, # 転送待ち
    transferred_not_yet_finalized: 1, # 転送済み,確定待ち
    completed: 9 # 完了
  }

  scope :not_yet_finalized, -> { where(status: %i[transferred_not_yet_finalized]) }
end
