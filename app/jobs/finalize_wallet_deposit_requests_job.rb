# frozen_string_literal: true

class FinalizeWalletDepositRequestsJob < BaseFinalizeRequestsJob
  queue_as :default

  def execute(request:)
    case request.status
    when 'issued_not_yet_finalized'
      # 当該リクエストのステータスを「移転待ち」に変更
      request.update!(status: :not_yet_transferred)
    when 'transferred_not_yet_finalized'
      account_transaction = request.account_transaction
      wallet = request.user.wallet
      amount = request.amount

      ActiveRecord::Base.transaction do
        # WalletTransaction の作成
        wallet_transaction = WalletTransaction.create!(
          wallet:,
          amount:,
          transaction_type: :deposit,
          transaction_time: Time.current
        )

        # FundsTransaction の作成
        FundsTransaction.create!(
          source: account_transaction,
          target: wallet_transaction,
          transaction_type: :wallet_deposit,
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
    WalletDepositRequest.not_yet_finalized
  end

  def tx_payload(request:)
    return request.tapyrus_issue_transaction_payload_hex if request.status == 'issued_not_yet_finalized'
    return request.tapyrus_transfer_transaction_payload_hex if request.status == 'transferred_not_yet_finalized'
  end
end
