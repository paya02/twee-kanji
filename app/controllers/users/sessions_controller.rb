class Users::SessionsController < Devise::SessionsController
  # skip_before_action :verify_signed_out_user, :only => :destroy

  def new
    super
  end
 
  def create
    #emailだけでログインできるように変更
    self.resource = User.where(:email => params[:user]['email']).first

    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    # respond_with resource, :location => after_sign_in_path_for(resource)
    redirect_to events_url
  end
 
  def destroy
    super
  end
end