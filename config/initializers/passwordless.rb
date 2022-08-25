Passwordless.default_from_address = "МДС Музыка <info@mds.redde.ru>"
Passwordless.parent_mailer = "ActionMailer::Base"
Passwordless.restrict_token_reuse = true
Passwordless.redirect_back_after_sign_in = true
Passwordless.expires_at = lambda { 1.year.from_now } # How long until a passwordless session expires.
Passwordless.timeout_at = lambda { 1.hour.from_now }

Passwordless.after_session_save = lambda do |session, request|
  Passwordless::Mailer.magic_link(session).deliver_later
end
