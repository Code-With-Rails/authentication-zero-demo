# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '20d9bfa17b11cc68a550', '7000177de3c52c11f0d09145353e2f80c218c59c', scope: 'user:email'
end
