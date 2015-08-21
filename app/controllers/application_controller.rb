class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate
    if !current_user
      flash[:alert] = "You need to login"
      redirect_to :login
    end
  end

  def set_locale
    # I18n.locale = params[:locale] || I18n.default_locale
    FastGettext.locale = params[:locale] || I18n.default_locale
  end

end
