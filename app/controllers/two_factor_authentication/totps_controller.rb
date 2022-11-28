# frozen_string_literal: true

module TwoFactorAuthentication
  class TotpsController < ApplicationController
    before_action :require_sudo
    before_action :set_user
    before_action :set_totp

    def new
      @qr_code = RQRCode::QRCode.new(@totp.provisioning_uri(@user.email))
    end

    def create
      if @totp.verify(params[:code], drift_behind: 15)
        @user.update! otp_secret: params[:secret]
        redirect_to root_path, notice: '2FA is enabled on your account'
      else
        redirect_to two_factor_authentication_totp_path, alert: "That code didn't work. Please try again"
      end
    end

    def set_user
      @user = Current.user
    end

    def set_totp
      @totp = ROTP::TOTP.new(params[:secret] || ROTP::Base32.random, issuer: 'Code With Rails Demo')
    end
  end
end
