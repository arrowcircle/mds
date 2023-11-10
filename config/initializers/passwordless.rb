require "passwordless"
Passwordless.configure do |config|
  config.default_from_address = "МДС Музыка <info@mds.redde.ru>"
  config.parent_mailer = "ApplicationMailer"
  config.restrict_token_reuse = true
  config.redirect_back_after_sign_in = true
  config.token_generator = Passwordless::ShortTokenGenerator.new
  config.expires_at = lambda { 1.year.from_now } # How long until a passwordless session expires.
  config.timeout_at = lambda { 1.hour.from_now }
  config.redirect_to_response_options = {}

  config.after_session_save = lambda do |session, request|
    Passwordless::Mailer.sign_in(session, session.token).deliver_later
  end
end
