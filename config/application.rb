require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mds
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    I18n.default_locale = :ru
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "mds"
    config.action_mailer.deliver_later_queue_name = nil

    config.x.debug_html = ENV["DEBUG_HTML"].in?(%w[1 true yes])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Moscow"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
