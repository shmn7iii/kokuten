# frozen_string_literal: true

class BaseFinalizeRequestsJob < ApplicationJob
  queue_as :default

  def perform
    target_requests.each do |request|
      next if Glueby::Internal::RPC.client.getrawtransaction(target_transaction_txid(request:), true)['blockhash'].nil?

      execute(request:)
    end
  end

  def execute(request:)
    raise NotImplementedError
  end

  private

  def target_requests
    raise NotImplementedError
  end

  def target_transaction_txid(request:)
    raise NotImplementedError
  end
end
