# frozen_string_literal: true

class BurnTokenFromWalletWithdrawalRequestsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(*_args)
    target_requests.each do |request|
      token = request.token
      amount = request.amount
      wallet = request.user.wallet

      tx = token.burn!(wallet:, amount:)

      ActiveRecord::Base.transaction do
        # TokenTransaction の作成
        token_transaction = TokenTransaction.create!(
          token:,
          amount: -amount,
          tapyrus_transaction_payload_hex: tx.to_payload.bth,
          transaction_type: :burn,
          transaction_time: Time.current
        )

        # WalletTransaction の作成
        wallet_transaction = WalletTransaction.create!(
          wallet:,
          amount: -amount,
          transaction_type: :withdrawal,
          transaction_time: Time.current
        )

        # 当該リクエストのステータスを「焼却済み確定待ち」に変更
        request.update!(
          status: :burned_not_yet_finalized,
          token_transaction:,
          wallet_transaction:,
          tapyrus_burn_transaction_payload_hex: tx.to_payload.bth
        )
      end
    end
  end

  private

  def target_requests
    WalletWithdrawalRequest.where(status: :not_yet_burned)
  end
end
