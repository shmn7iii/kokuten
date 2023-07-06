# frozen_string_literal: true

module Admin
  class UtxoProvidersController < Admin::ApplicationController
    before_action -> { title('UTXO Provider') }, only: %i[show]

    def show
      utxo_provider = Glueby::UtxoProvider.instance
      @current_tpc_amount = utxo_provider.tpc_amount
      @current_utxo_pool_size = utxo_provider.current_utxo_pool_size
      @configured_default_value = utxo_provider.default_value
      @configured_utxo_pool_size = utxo_provider.utxo_pool_size
    end
  end
end
