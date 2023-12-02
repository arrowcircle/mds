require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Specify AnyCable WebSocket server URL to use by JS client
  # config.after_initialize do
  #   config.action_cable.url = ActionCable.server.config.url = ENV.fetch("CABLE_URL", "/cable") if AnyCable::Rails.enabled?
  # end
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=31536000"
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # custom config
  # SSL
  if ENV["FORCE_SSL"] == "true"
    config.force_ssl = true
    config.ssl_options = {redirect: {exclude: ->(request) { request.path =~ /health_check/ }}}
  end

  # SMTP
  config.action_mailer.default_url_options = {host: "mds.redde.ru"}#ENV.fetch("DOMAIN_NAME", "mds.redde.ru")}
  # config.default_url_options[:host] ||= "mds.redde.ru"
  routes.default_url_options[:host] ||= "mds.redde.ru"

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    domain: "mds.redde.ru",
    address: ENV["SMTP_HOST"],
    port: ENV["SMTP_PORT"],
    user_name: ENV["SMTP_USER"],
    password: ENV["SMTP_PASSWORD"],
    authentication: :login,
    enable_starttls_auto: true
  }

  # LOGS
  config.lograge.enabled = true
  config.lograge.ignore_actions = ["WelcomeController#health_check"]

  # Sessions
  config.session_store :cookie_store, key: "_mds_session", expire_after: 1.year
end
