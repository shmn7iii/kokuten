# frozen_string_literal: true

class IssueTokenFromWalletDepositRequestsJob < ApplicationJob
  queue_as :default

  # TODO: issue! がリトライ不可なのでひとまず false
  # issue! と Transaction生成部を分けるなりしてなんとか再実行可能にしたい
  sidekiq_options retry: false

  def perform
    target_requests.each do |request|
      token = request.token
      amount = request.amount

      _, tx = token.glueby_token.reissue!(issuer: Wallet.utxo_provider_wallet.glueby_wallet, amount:)

      ActiveRecord::Base.transaction do
        # TokenTransaction の作成
        token_transaction = TokenTransaction.create!(
          token:,
          amount:,
          tapyrus_transaction_payload_hex: tx.to_payload.bth,
          transaction_type: :issue,
          transaction_time: Time.current
        )

        # 当該リクエストのステータスを「発行済み確定待ち」に変更
        request.update!(
          status: :issued_not_yet_finalized,
          token_transaction:,
          tapyrus_issue_transaction_payload_hex: tx.to_payload.bth
        )
      end
    end
  end

  private

  def target_requests
    WalletDepositRequest.where(status: :not_yet_issued)
  end
end
