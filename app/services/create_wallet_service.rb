# frozen_string_literal: true

class CreateWalletService < BaseService
  def initialize(user:)
    @user = user
  end

  def call
    glueby_wallet = Glueby::Wallet.create
    wallet = @user.build_wallet(glueby_wallet_id: glueby_wallet.id)
    wallet.save!
  end
end
