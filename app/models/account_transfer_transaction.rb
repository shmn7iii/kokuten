# frozen_string_literal: true

class AccountTransferTransaction < ApplicationRecord
  belongs_to :source, class_name: 'AccountTransaction'
  belongs_to :target, class_name: 'AccountTransaction'
end
