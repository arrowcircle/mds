# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 7.0"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem "webpacker", "~> 5.1"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# gem "redis-client"

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Hotwire"s SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "1.5.0"

# Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# gem "propshaft"
# gem "jsbundling-rails"
# gem "cssbundling-rails"
gem "vite_rails"

# Use ActiveStorage variant
# gem "mini_magick", "~> 4.8"

# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "debug", platforms: %i[ mri mingw x64_mingw ]
  # gem "irb", "1.3.6"
  # gem "reline", "0.2.7"
  gem "bundle-audit"
  gem "dotenv-rails"
  gem "ffaker"
  gem "haml_lint", require: false
  gem "rubocop-rails"
  gem "lefthook"
  gem "standard"
end

group :development do
  gem "letter_opener"

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # # For memory profiling
  # gem "memory_profiler"

  # # For call-stack profiling flamegraphs
  # gem "stackprof"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "dockerfile-rails"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Application deps
gem "aws-sdk-s3", "~> 1.14"
gem "email_validator"
gem "hamlit-rails"
gem "imgproxy"
gem "lograge"
gem "meilisearch"
gem "mini_mime"
gem "pagy"
gem "passwordless"
gem "russian"
gem "shrine"
gem "sidekiq", "<8"
gem "sidekiq-cron"
gem "store_attribute", "~> 1.0"
gem "view_component"
# gem "view_component-contrib"
gem "webrick"
gem "yabeda-rails"
gem "yabeda-sidekiq"
gem "yabeda-http_requests"
gem "yabeda-puma-plugin"
gem "yabeda-prometheus" # , github: "yabeda-rb/yabeda-prometheus", ref: "7746697"
