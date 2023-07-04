# frozen_string_literal: true

WebAuthn.configure do |config|
  config.origin = ENV['WEBAUTHN_ORIGIN']
  config.rp_name = 'Kokuten'
end
