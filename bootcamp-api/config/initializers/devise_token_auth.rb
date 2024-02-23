# frozen_string_literal: true

DeviseTokenAuth.setup do |config|
  # Faz o token mudar a cada requisição
  config.change_headers_on_each_request = true

  # Mudanca de senha
  config.require_client_password_reset_token = true

  # Vida util do token
  config.token_lifespan = 1.weeks

  config.token_cost = Rails.env.test? ? 4 : 10

  # Requests em massa
  config.batch_request_buffer_throttle = 5.seconds

  # This route will be the prefix for all oauth2 redirect callbacks. For
  # example, using the default '/omniauth', the github oauth2 provider will
  # redirect successful authentications to '/omniauth/github/callback'
  # config.omniauth_prefix = "/omniauth"

  # config.check_current_password_before_update = :attributes

  # By default we will use callbacks for single omniauth.
  # It depends on fields like email, provider and uid.
  # config.default_callbacks = true


  # By default, only Bearer Token authentication is implemented out of the box.
  # If, however, you wish to integrate with legacy Devise authentication, you can
  # do so by enabling this flag. NOTE: This feature is highly experimental!
  # config.enable_standard_devise_support = false

  # By default DeviseTokenAuth will not send confirmation email, even when including
  # devise confirmable module. If you want to use devise confirmable module and
  # send email, set it to true. (This is a setting for compatibility)
  # config.send_confirmation_email = true
end
