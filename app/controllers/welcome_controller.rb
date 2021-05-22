# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
  end

  def health_check
    Rails.logger.silence do
      begin
        ActiveRecord::Base.connection
        User.first
        Redis.current.get('healthcheck')
        obj = { msg: 'success', status_code: 200, status: 'healthy' }
      rescue ActiveRecord::NoDatabaseError
        obj = { msg: 'failure', status_code: 500, status: 'unhealthy' }
      end
      respond_to do |format|
        format.html { render plain: obj[:msg], status: obj[:status_code], content_type: 'text/plain' }
        format.json { render json: obj.except(:status_code), status: obj[:status_code] }
        format.any { render plain: obj[:msg], status: obj[:status_code], content_type: 'text/plain' }
      end
    end
  end

end
