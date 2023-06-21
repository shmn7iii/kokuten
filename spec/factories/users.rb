# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'shimamura.hayato' }
    first_name { '嶋村' }
    last_name { '颯人' }
    phone_number { 0o0000000000 }
    email { '2011140075w@ed.fuk.kindai.ac.jp' }
  end
end
