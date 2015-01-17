class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: :json_request?

  def json_request?
    request.format.json?
  end


  def authenticate
    if Rails.env.development? || Rails.env.test?
      true
    else
      auths.any? {|auth| params[:auth].match auth }
    end
  end

  def auths
    [ENV.fetch('AUTH')]
  end
end
