# frozen_string_literal: true

namespace :kokuten do
  namespace :glueby do
    desc 'Init glueby'
    task init: :environment do
      puts "\n== Generate block =="
      utxo_provider_address = Glueby::UtxoProvider.instance.address
      aggregate_private_key = ENV['AUTHORITY_KEY']
      txs = Glueby::Internal::RPC.client.generatetoaddress(1, utxo_provider_address, aggregate_private_key)
      puts txs

      puts "\n== Start BlockSyncer =="
      Rake::Task['glueby:block_syncer:start'].invoke
      Rake::Task['glueby:block_syncer:start'].reenable

      puts "\n== Manage UTXO Provider's UTXO pool =="
      Glueby::UtxoProvider::Tasks.new.manage_utxo_pool

      puts "\n== Generate block =="
      utxo_provider_address = Glueby::UtxoProvider.instance.address
      aggregate_private_key = ENV['AUTHORITY_KEY']
      txs = Glueby::Internal::RPC.client.generatetoaddress(1, utxo_provider_address, aggregate_private_key)
      puts txs

      puts "\n== Start BlockSyncer =="
      Rake::Task['glueby:block_syncer:start'].invoke

      puts "\n== Show UTXO Provider status =="
      Glueby::UtxoProvider::Tasks.new.status
    end

    desc "Manage UTXO Provider's UTXO pool and generate block, start block_syncer"
    task manage_utxo: :environment do
      puts "== Manage UTXO Provider's UTXO pool =="
      Glueby::UtxoProvider::Tasks.new.manage_utxo_pool

      puts "\n== Generate block =="
      utxo_provider_address = Glueby::UtxoProvider.instance.address
      aggregate_private_key = ENV['AUTHORITY_KEY']
      txs = Glueby::Internal::RPC.client.generatetoaddress(1, utxo_provider_address, aggregate_private_key)
      puts txs

      puts "\n== Start BlockSyncer =="
      Rake::Task['glueby:block_syncer:start'].invoke

      puts "\n== Show UTXO Provider status =="
      Glueby::UtxoProvider::Tasks.new.status
    end

    desc 'Generate block, start block_syncer'
    task generate: :environment do
      puts "\n== Generate block =="
      utxo_provider_address = Glueby::UtxoProvider.instance.address
      aggregate_private_key = ENV['AUTHORITY_KEY']
      txs = Glueby::Internal::RPC.client.generatetoaddress(1, utxo_provider_address, aggregate_private_key)
      puts txs

      puts "\n== Start BlockSyncer =="
      Rake::Task['glueby:block_syncer:start'].invoke
    end
  end
end
