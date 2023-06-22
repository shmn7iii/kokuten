# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :signed_in?, only: %i[show]

  def show
    @account = current_user.account
  end
end
