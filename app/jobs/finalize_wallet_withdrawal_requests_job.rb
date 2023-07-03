# frozen_string_literal: true

class FinalizeWalletWithdrawalRequestsJob < BaseFinalizeRequestsJob
  queue_as :default

  def execute(request:)
    case request.status
    when 'burned_not_yet_finalized'
      wallet_transaction = request.wallet_transaction
      account = request.user.account
      amount = request.amount

      ActiveRecord::Base.transaction do
        # AccountTransaction の作成
        account.update!(balance: account.balance + amount)
        account_transaction = AccountTransaction.create!(
          account:,
          amount:,
          transaction_type: :transfer,
          transaction_time: Time.current
        )

        # FundsTransaction の作成
        FundsTransaction.create!(
          source: wallet_transaction,
          target: account_transaction,
          transaction_type: :wallet_withdrawal,
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
    WalletWithdrawalRequest.not_yet_finalized
  end

  def target_transaction_txid(request:)
    return request.tapyrus_burn_transaction_txid if request.status == 'burned_not_yet_finalized'
  end
end
