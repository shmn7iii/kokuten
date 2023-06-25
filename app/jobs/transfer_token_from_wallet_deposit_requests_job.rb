# frozen_string_literal: true

class TransferTokenFromWalletDepositRequestsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform
    target_requests.each do |request|
      token = request.token
      wallet = request.user.wallet
      amount = request.amount

      _, tx = token.glueby_token.transfer!(
        sender: Wallet.utxo_provider_wallet.glueby_wallet,
        receiver_address: wallet.glueby_wallet.internal_wallet.receive_address,
        amount:
      )

      # 当該リクエストのステータスを「移転済み確定待ち」に変更
      request.update!(
        status: :transferred_not_yet_finalized,
        tapyrus_transfer_transaction_payload_hex: tx.to_payload.bth
      )
    end
  end

  private

  def target_requests
    WalletDepositRequest.where(status: :not_yet_transferred)
  end
end
