# frozen_string_literal: true

class TransferTokenFromWalletDepositRequestsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform
    target_requests.each do |request|
      token = request.token
      wallet = request.user.wallet
      amount = request.amount

      tx = token.transfer!(
        sender: Wallet.utxo_provider_wallet,
        receiver: wallet,
        amount:
      )

      # 当該リクエストのステータスを「移転済み確定待ち」に変更
      request.update!(
        status: :transferred_not_yet_finalized,
        tapyrus_transfer_transaction_txid: tx.txid
      )
    end
  end

  private

  def target_requests
    WalletDepositRequest.where(status: :not_yet_transferred)
  end
end
