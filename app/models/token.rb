# frozen_string_literal: true

# サービス内で流通するトークンを管理するモデル
class Token < ApplicationRecord
  validates :script_pubkey_payload_hex, presence: true

  has_many :token_transactions

  TOKEN_ID = 1 # TODO: .envにでも書きたい

  def self.instance
    find_or_create_by!(id: TOKEN_ID)
  end

  def total_amount
    tx_outset_info = Glueby::Internal::RPC.client.gettxoutsetinfo
    tx_outset_info['total_amount'][glueby_token.color_id.to_payload.bth]
  end

  # color_id の payload を保存したかったが、Glueby::Contract::Token.parse_from_payload だと ActiveRecord へ保存してしまう。
  # Tapyrus::Color::ColorIdentifier.parse_from_payload してから Token を new すると token_type がずれる。
  # ので script_pubkey を保存することにした。
  def glueby_token
    script_pubkey = Tapyrus::Script.parse_from_payload(script_pubkey_payload_hex.htb)
    color_identifier = Tapyrus::Color::ColorIdentifier.reissuable(script_pubkey)
    Glueby::Contract::Token.new(color_id: color_identifier)
  end
end
