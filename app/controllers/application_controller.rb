class ApplicationController < ActionController::Base
  # alias_method :devise_current_user, :current_user

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, :notice => 'ログインすると機能を使えるようになります。'
    end
  end

end
