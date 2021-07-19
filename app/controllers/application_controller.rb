class ApplicationController < ActionController::Base
  def gon_current_user
    gon.push({ current_user_id: current_user&.id })
  end
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
    format.js { render status: :forbidden }
    format.json { render json: exception.message, status: :forbidden }
  end

  check_authorization unless: :devise_controller?
end
