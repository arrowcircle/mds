Imgproxy.configure do |config|
  # imgproxy endpoint
  #
  # Full URL to where your imgproxy lives.
  config.endpoint = ENV['IMGPROXY_ENDPOINT']

  # Next, you have to provide your signature key and salt.
  # If unsure, check out https://github.com/imgproxy/imgproxy/blob/master/docs/configuration.md first.

  # Hex-encoded signature key

  config.key = ENV['IMGPROXY_KEY'] if ENV['IMGPROXY_KEY']
  # Hex-encoded signature salt
  config.salt = ENV['IMGPROXY_SALT'] if ENV['IMGPROXY_SALT']
  config.use_s3_urls = true
end

Imgproxy.extend_shrine!
