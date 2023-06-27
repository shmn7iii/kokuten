# frozen_string_literal: true

module Glueby
  class GenerateBlockJob < ApplicationJob
    queue_as :default

    def perform
      return unless Tapyrus.chain_params.dev?

      # Generate block to UTXO Provider's address
      utxo_provider_address = Glueby::UtxoProvider.instance.address
      aggregate_private_key = ENV['TAPYRUS_AUTHORITY_KEY']
      Glueby::Internal::RPC.client.generatetoaddress(1, utxo_provider_address, aggregate_private_key)
    end
  end
end
