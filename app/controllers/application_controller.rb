# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_current_request_details
  before_action :authenticate

  def require_sudo
    return if Current.session.sudo?

    redirect_to new_sessions_sudo_path(proceed_to_url: request.url)
  end

  private

  def authenticate
    if session = Session.find_by_id(cookies.signed[:session_token])
      Current.session = session
    else
      redirect_to sign_in_path
    end
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end
end
