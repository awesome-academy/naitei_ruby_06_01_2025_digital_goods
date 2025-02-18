class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.users.not_found"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.please_log_in"
    redirect_to login_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t "flash.users.cannot_access"
    redirect_to root_url
  end
end
