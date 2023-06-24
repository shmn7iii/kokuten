# frozen_string_literal: true

module Glueby
  class BlockGenerateJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      # Generate block to UTXO Provider's address
      utxo_provider_address = Glueby::UtxoProvider.instance.address
      aggregate_private_key = ENV['AUTHORITY_KEY']
      Glueby::Internal::RPC.client.generatetoaddress(1, utxo_provider_address, aggregate_private_key)

      # Start BlockSyncer
      # source: https://github.com/chaintope/glueby/blob/master/lib/tasks/glueby/block_syncer.rake#L17
      latest_block_num = Glueby::Internal::RPC.client.getblockcount
      synced_block = Glueby::AR::SystemInformation.synced_block_height
      (synced_block.int_value + 1..latest_block_num).each do |height|
        Glueby::BlockSyncer.new(height).run
        synced_block.update(info_value: height.to_s)
      end
    end
  end
end
