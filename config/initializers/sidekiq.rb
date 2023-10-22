# MONKEY PATCHING
require "rackup"
module Yabeda
  module Prometheus
    class Exporter < ::Prometheus::Middleware::Exporter
      class << self
        def start_metrics_server!(**rack_app_options)
          Thread.new do
            default_port = ENV.fetch("PORT", 9394)
            ::Rackup::Handler::WEBrick.run(
              rack_app(**rack_app_options),
              Host: ENV["PROMETHEUS_EXPORTER_BIND"] || "0.0.0.0",
              Port: ENV.fetch("PROMETHEUS_EXPORTER_PORT", default_port),
              AccessLog: [],
            )
          end
        end
      end
    end
  end
end

module Mds
  def self.redis
    @redis ||= ConnectionPool::Wrapper.new do
      Redis.new(url: ENV["REDIS_URL"])
    end
  end
end

Sidekiq.configure_server do |_config|
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
