# frozen_string_literal: true

class BaseFinalizeRequestsJob < ApplicationJob
  queue_as :default

  def perform
    target_requests.each do |request|
      puts '==='
      puts tx_payload(request:)
      tx = Tapyrus::Tx.parse_from_payload(tx_payload(request:).htb)
      next if Glueby::Internal::RPC.client.getrawtransaction(tx.txid, true)['blockhash'].nil?

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

  def tx_payload(request:)
    raise NotImplementedError
  end
end
