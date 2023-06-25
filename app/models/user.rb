# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :phone_number, presence: true
  validates :email, presence: true, length: { maximum: 255 }

  has_one :account
  has_one :wallet

  has_many :wallet_deposit_requests
  has_many :wallet_withdrawal_requests
  has_many :wallet_transfer_requests_as_sender, class_name: 'WalletTransferRequest', foreign_key: 'sender_id'
  has_many :wallet_transfer_requests_as_receiver, class_name: 'WalletTransferRequest', foreign_key: 'receiver_id'

  def wallet_transfer_requests
    [
      wallet_transfer_requests_as_sender,
      wallet_transfer_requests_as_receiver
    ].flatten!
  end
end
