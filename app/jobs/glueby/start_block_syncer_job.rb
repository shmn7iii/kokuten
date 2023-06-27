# frozen_string_literal: true

module Glueby
  class StartBlockSyncerJob < ApplicationJob
    queue_as :default

    def perform
      # Generate block if :dev chain
      GenerateBlockJob.perform_now if Tapyrus.chain_params.dev?

      # Start BlockSyncer
      # source: https://github.com/chaintope/glueby/blob/master/lib/tasks/glueby/block_syncer.rake#L17
      latest_block_num = Glueby::Internal::RPC.client.getblockcount
      synced_block = Glueby::AR::SystemInformation.synced_block_height
      (synced_block.int_value + 1..latest_block_num).each do |height|
        Glueby::BlockSyncer.new(height).run
        synced_block.update(info_value: height.to_s)
      end

      # Try to finalize requests
      FinalizeWalletDepositRequestsJob.perform_now
      FinalizeWalletWithdrawalRequestsJob.perform_now
      FinalizeWalletTransferRequestsJob.perform_now
    end
  end
end
