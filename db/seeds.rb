# frozen_string_literal: true

Glueby::AR::SystemInformation.create(info_key: 'synced_block_number', info_value: '0') if Glueby::AR::SystemInformation.synced_block_height.nil?
