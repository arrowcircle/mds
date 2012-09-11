Airbrake.configure do |config|
  config.api_key     = '0d1f592a2386abc784562b8e26305a02'
  config.host        = 'errbit.redde.ru'
  config.port        = 80
  config.secure      = config.port == 443
end