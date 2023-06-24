# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    association :user
    balance { 0 }
    account_number { format('%07d', SecureRandom.random_number(10**7)) }
    branch_code { '101' }
    branch_name { '本店' }
  end
end
