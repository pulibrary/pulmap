# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  before_action :allow_geoblacklight_params

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  RESCUE_WITH_404 = [
    Blacklight::Exceptions::RecordNotFound
  ].freeze

  rescue_from(*RESCUE_WITH_404) do
    render file: Rails.public_path.join("404.html"), status: :not_found
  end

  def allow_geoblacklight_params
    # Blacklight::Parameters will pass these to params.permit
    blacklight_config.search_state_fields.append(Settings.GBL_PARAMS)
  end

  def after_sign_in_path_for(_resource)
    if !request.env["omniauth.origin"].nil?
      request.env["omniauth.origin"]
    else
      root_path
    end
  end
end
