# frozen_string_literal: true

module Wallets
  class TransferService < BaseService
    # @param [User] sender
    # @param [User] receiver
    # @param [Integer] amount
    def initialize(sender:, receiver:, amount:)
      @sender = sender
      @receiver = receiver
      @amount = amount

      @token = Token.instance
    end

    def call
      # TODO: 残高不足の回避
      # return しなきゃいけない && 非同期なのであらかじめ残高確保したい

      # TODO: Receiver のウォレット未開設回避
      # デフォルトではウォレット作らず、別規約に同意で作成の手順なのでデフォルトでウォレット存在せず
      # コントローラーで弾くなりしたい

      # TODO: ここで複数のリクエストを作ればいい？

      WalletTransferRequest.create!(
        token: @token,
        sender: @sender,
        receiver: @receiver,
        amount: @amount,
        status: :not_yet_transferred
      )
    end
  end
end
