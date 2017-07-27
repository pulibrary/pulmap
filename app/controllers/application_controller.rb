class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def after_sign_in_path_for(_resource)
    if !request.env['omniauth.origin'].nil?
      request.env['omniauth.origin']
    else
      root_path
    end
  end
end
