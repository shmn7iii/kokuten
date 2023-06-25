# frozen_string_literal: true

class FinalizeWalletTransferRequestsJob < BaseFinalizeRequestsJob
  queue_as :default

  def execute(request:)
    case request.status
    when 'transferred_not_yet_finalized'
      sender = request.sender
      receiver = request.receiver
      amount = request.amount

      ActiveRecord::Base.transaction do
        # WalletTransaction の作成
        source = WalletTransaction.create!(
          wallet: sender.wallet,
          amount: -amount,
          transaction_type: :transfer,
          transaction_time: Time.current
        )

        target = WalletTransaction.create!(
          wallet: receiver.wallet,
          amount:,
          transaction_type: :transfer,
          transaction_time: Time.current
        )

        # FundsTransaction の作成
        FundsTransaction.create!(
          source:,
          target:,
          transaction_type: :wallet_transfer,
          transaction_time: Time.current
        )

        # 当該リクエストのステータスを「完了」に変更
        request.update!(
          status: :completed,
          completion_time: Time.current
        )
      end
    end
  end

  private

  def target_requests
    WalletTransferRequest.not_yet_finalized
  end

  def tx_payload(request:)
    return request.tapyrus_transfer_transaction_payload_hex if request.status == 'transferred_not_yet_finalized'
  end
end
