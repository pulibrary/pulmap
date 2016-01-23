class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def after_sign_in_path_for(_resource)
    blacklist = [new_user_session_path, new_user_registration_path]
    last_url = URI.parse(request.referer).path if request.referer
    if !last_url || blacklist.include?(last_url)
      last_url
    else
      last_url
    end
  end

  def after_sign_out_path_for(_resource)
    last_url = URI.parse(request.referer).path if request.referer
    last_url || root_path
  end
end
