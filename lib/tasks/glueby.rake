# frozen_string_literal: true

namespace :glueby do
  desc 'Generate block and start block_syncer'
  task generate: :environment do
    utxo_provider_address = Glueby::UtxoProvider.instance.address
    aggregate_private_key = ENV['AUTHORITY_KEY']
    Glueby::Internal::RPC.client.generatetoaddress(1, utxo_provider_address, aggregate_private_key)
    Rake::Task['glueby:block_syncer:start'].invoke
  end
end
