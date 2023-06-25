# frozen_string_literal: true

module Glueby
  class ManageUtxoPoolJob < ApplicationJob
    queue_as :default

    def perform
      # Manage UTXO Provider's UTXO pool
      Glueby::UtxoProvider::Tasks.new.manage_utxo_pool
    end
  end
end
