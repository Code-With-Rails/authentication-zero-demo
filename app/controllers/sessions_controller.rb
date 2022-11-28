# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      if user.otp_secret
        signed_id = user.signed_id(purpose: :authentication_challenge, expires_in: 20.minutes)

        redirect_to new_two_factor_authentication_challenge_path(token: signed_id)
      else
        @session = user.sessions.create!
        cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

        redirect_to root_path, notice: 'Signed in successfully'
      end
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: 'That email or password is incorrect'
    end
  end

  def destroy
    @session.destroy
    redirect_to(sessions_path, notice: 'That session has been logged out')
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end
end
