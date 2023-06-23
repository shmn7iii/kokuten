# frozen_string_literal: true

class Token < ApplicationRecord
  validates :script_pubkey_payload_hex, presence: true

  has_many :token_transactions

  after_initialize do
    self.script_pubkey_payload_hex ||= create_token.script_pubkey.to_payload.bth
  end

  TOKEN_ID = 1 # TODO: .envにでも書きたい

  def self.instance
    find_or_create_by!(id: TOKEN_ID)
  end

  def total_amount
    tx_outset_info = Glueby::Internal::RPC.client.gettxoutsetinfo
    tx_outset_info['total_amount'][glueby_token.color_id.to_payload.bth]
  end

  def amount(wallet:)
    glueby_token.amount(wallet:)
  end

  # すげえ時間かかるので非同期化なりどうにかしたい気持ち
  def issue!(wallet:, amount:)
    _, tx = glueby_token.reissue!(issuer: utxo_provider_wallet, amount:)
    system('bundle exec rake kokuten:glueby:generate')
    glueby_token.transfer!(sender: utxo_provider_wallet,
                           receiver_address: wallet.glueby_wallet.internal_wallet.receive_address,
                           amount:)
    system('bundle exec rake kokuten:glueby:generate')
    tx
  end

  def burn!(wallet:, amount:)
    tx = glueby_token.burn!(sender: wallet.glueby_wallet, amount:)
    system('bundle exec rake kokuten:glueby:generate')
    tx
  end

  private

  # color_id の payload を保存したかったが、Glueby::Contract::Token.parse_from_payload だと ActiveRecord へ保存してしまう。
  # Tapyrus::Color::ColorIdentifier.parse_from_payload してから Token を new すると token_type がずれる。
  # ので script_pubkey を保存することにした。
  def glueby_token
    script_pubkey = Tapyrus::Script.parse_from_payload(script_pubkey_payload_hex.htb)
    color_identifier = Tapyrus::Color::ColorIdentifier.reissuable(script_pubkey)
    Glueby::Contract::Token.new(color_id: color_identifier)
  end

  # 発行者は UTXO Provider とする。1枚作って script_pubkey を作り即座に burn する。
  # FIXME: administrate で Token のページ見る度に走ってそう。
  def create_token
    token, txs = Glueby::Contract::Token.issue!(issuer: utxo_provider_wallet, amount: 1,
                                                token_type: Tapyrus::Color::TokenTypes::REISSUABLE)
    system('bundle exec rake kokuten:glueby:generate')

    token.burn!(sender: utxo_provider_wallet, amount: 1)
    system('bundle exec rake kokuten:glueby:generate')

    token
  end

  # Glueby::UtxoProvider.instance.wallet は Glueby::Internal::Wallet クラスなため使わない。
  def utxo_provider_wallet
    Glueby::Wallet.load('UTXO_PROVIDER_WALLET')
  end
end
