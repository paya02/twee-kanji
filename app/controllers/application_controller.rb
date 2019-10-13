class ApplicationController < ActionController::Base
  alias_method :devise_current_user, :current_user

  protected
  def authenticate_user!
    if session[:user_id] then
      true
    elsif user_signed_in?
      super
    else
      redirect_to root_path, :notice => 'ログインすると機能を使えるようになります。'
    end
  end

  def current_user
    if session[:user_id] then
      @current_user ||= User.find_by(id: session[:user_id])
    elsif devise_current_user.nil?
      devise_current_user
    else
      User.find_by_id(devise_current_user.id)
    end
  end
end
