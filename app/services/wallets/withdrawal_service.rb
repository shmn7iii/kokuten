# frozen_string_literal: true

module Wallets
  class WithdrawalService < BaseService
    # @param [User] user
    # @param [Integer] amount
    def initialize(user:, amount:)
      @user = user
      @amount = amount

      @token = Token.instance
    end

    def call
      # TODO: 残高不足の回避
      # return しなきゃいけない && 非同期なのであらかじめ残高確保したい

      WalletWithdrawalRequest.create!(
        token: @token,
        user: @user,
        amount: @amount,
        status: :not_yet_burned
      )
    end
  end
end
