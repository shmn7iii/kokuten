# frozen_string_literal: true

module Admin
  class ApplicationController < ActionController::Base
    before_action :basic_auth

    private

    def basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['ADMIN_PAGE_BASIC_AUTH_USER'] && password == ENV['ADMIN_PAGE_BASIC_AUTH_PASSWORD']
      end
    end

    def previous_path(path)
      @previous_path = path
    end

    def title(title)
      @title = title
    end
  end
end
