class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    #strong parametersを設定し、usernameを許可
    devise_parameter_sanitizer.for(:sign_up, ) { |u| u.permit(:email, :code, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.for(:account_update, ) { |u| u.permit(:email, :code, :password, :password_confirmation, :current_password) }
  end  
end
