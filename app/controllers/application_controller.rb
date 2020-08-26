# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  rescue ActionController::RoutingError
    render_404
  end

  private

  def after_sign_in_path_for(_resource)
    if !request.env['omniauth.origin'].nil?
      request.env['omniauth.origin']
    else
      root_path
    end
  end

  def render_404
    render file: Rails.root.join("public", "404"), status: :not_found
  end
end
