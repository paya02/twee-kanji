class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user, :only => :destroy

  def new
    super
  end
 
  def create
    super
  end
 
  def destroy
    if session[:user_id] then
      session.delete(:user_id)
      redirect_to root_url, :notice => I18n.t('devise.sessions.signed_out')
    else
      super
    end
  end
end