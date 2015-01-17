class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
