# frozen_string_literal: true

module Admin
  class UsersController < Admin::ApplicationController
    before_action -> { title('Users') }, only: %i[index]
    before_action -> { title("User ##{params[:id]}") }, only: %i[show]
    before_action -> { previous_path(admin_users_path) }, only: %i[show]

    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end
  end
end
