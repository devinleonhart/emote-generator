class ApplicationController < ActionController::Base
  # There is no session, and no request changes anything.
  skip_forgery_protection

  rate_limit to: 5000, within: 1.hour, scope: "all", with: -> { head :too_many_requests }

  private

  # As nginx says of every answer.
  def keep_for_a_week
    expires_in 1.week, public: true
  end

  def plain(status)
    render plain: Rack::Utils::HTTP_STATUS_CODES.fetch(Rack::Utils.status_code(status)), status:
  end

  def picture(bytes)
    keep_for_a_week
    send_data bytes, type: "image/png", disposition: "inline"
  end
end
