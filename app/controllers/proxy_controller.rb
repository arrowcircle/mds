class ProxyController < ApplicationController
  include ActiveStorage::Streaming
  def show
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

    filename = params[:url].split("/").last.split("?").first

    res = HTTP.follow.get(params[:url].to_s, ssl_context: ctx)
    send_stream(
      filename:,
      disposition: "inline; filename='#{filename}'",
      type: "audio/mpeg"
    ) do |stream|
      res.body.each do |chunk|
        stream.write chunk
      end
    end
  end
end
