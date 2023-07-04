# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  private

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def signed_in?
    return if current_user

    redirect_to login_path
  end
end
