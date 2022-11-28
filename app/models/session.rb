# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user

  kredis_flag :sudo, expires_in: 30.minutes

  before_create do
    self.user_agent = Current.user_agent
    self.ip_address = Current.ip_address
  end

  after_create_commit do
    sudo.mark
  end

  after_create_commit do
    SessionMailer.with(session: self).signed_in_notification.deliver_later
  end
end
