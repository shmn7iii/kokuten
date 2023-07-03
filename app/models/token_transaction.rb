# frozen_string_literal: true

# トークンの増減を管理するモデル
class TokenTransaction < ApplicationRecord
  validates :amount, presence: true
  validates :tapyrus_transaction_txid, presence: true
  validates :transaction_type, presence: true
  validates :transaction_time, presence: true

  belongs_to :token

  enum transaction_type: {
    issue: 0, # 発行
    burn: 1 # 焼却
  }

  def description
    case transaction_type
    when 'issue'
      'トークンの発行・追加発行'
    when 'burn'
      'トークンの焼却'
    else
      raise NotImplementedError
    end
  end
end
