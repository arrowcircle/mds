class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  default from: "МДС Музыка <info@mds.redde.ru>"
  layout "mailer"
end
