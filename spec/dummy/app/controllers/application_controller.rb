class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    URI(request.referer).path == '/caseadilla/sign_in' ? caseadilla_root_path : root_path
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit({ role_ids: [] }, :email, :password, :password_confirmation, :current_password, :first_name, :last_name, :time_zone) }
  end

end
