# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :signed_in?, only: %i[show]

  def show
    @user = current_user
  end

  def new; end

  def create
    user = User.new(user_params)

    create_options = WebAuthn::Credential.options_for_create(
      user: {
        name: user_params[:username],
        id: user.webauthn_id
      },
      authenticator_selection: { user_verification: 'required' }
    )

    if user.valid?
      session[:current_registration] = { challenge: create_options.challenge, user_attributes: user.attributes }

      respond_to do |format|
        format.json { render json: create_options }
      end
    else
      redirect_to signup_path, alert: user.errors.full_messages.join('<br>')
    end
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_create(params)

    ActiveRecord::Base.transaction do
      user = User.create!(session['current_registration']['user_attributes'])
      user.build_account.save!

      begin
        webauthn_credential.verify(session['current_registration']['challenge'], user_verification: true)

        credential = user.credentials.build(
          external_id: Base64.strict_encode64(webauthn_credential.raw_id),
          nickname: 'default',
          public_key: webauthn_credential.public_key,
          sign_count: webauthn_credential.sign_count
        )

        if credential.save
          sign_in(user)

          render json: { status: 'ok' }, status: :ok
        else
          render json: "Couldn't register your Security Key", status: :unprocessable_entity
        end
      rescue WebAuthn::Error => e
        render json: "Verification failed: #{e.message}", status: :unprocessable_entity
      ensure
        session.delete('current_registration')
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :phone_number, :email)
  end
end
