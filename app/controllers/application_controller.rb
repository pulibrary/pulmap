class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :store_current_location, unless: :devise_controller?

  private

  def store_current_location
    store_location_for(:user, request.url)
  end
end
