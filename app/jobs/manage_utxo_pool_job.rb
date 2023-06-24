# frozen_string_literal: true

class ManageUtxoPoolJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Manage UTXO Provider's UTXO pool
    Glueby::UtxoProvider::Tasks.new.manage_utxo_pool
  end
end
