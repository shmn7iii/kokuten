# frozen_string_literal: true

# Create SystemInformation
if Glueby::AR::SystemInformation.synced_block_height.nil?
  Glueby::AR::SystemInformation.create(info_key: 'synced_block_number', info_value: '0')
end

# Create UTXO Provider
# glueby_wallet_id が UTXO_PROVIDER_WALLET なことは自明だがインスタンスの生成のため呼び出し
glueby_wallet_id = Glueby::UtxoProvider.instance.wallet.id
utxo_provider_wallet = Wallet.create!(glueby_wallet_id:)

# Create Token
# UTXO Provider に資金を送る
Glueby::BlockGenerateJob.perform_now
Glueby::ManageUtxoPoolJob.perform_now
Glueby::BlockGenerateJob.perform_now

token, = Glueby::Contract::Token.issue!(
  issuer: utxo_provider_wallet.glueby_wallet,
  token_type: Tapyrus::Color::TokenTypes::REISSUABLE,
  amount: 1
)
Glueby::BlockGenerateJob.perform_now

token.burn!(sender: utxo_provider_wallet.glueby_wallet, amount: 1)
Glueby::BlockGenerateJob.perform_now

Token.create!(script_pubkey_payload_hex: token.script_pubkey.to_payload.bth)
