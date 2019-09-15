class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    callback_from :twitter
  end

  private

  def callback_from(provider)
    provider = provider.to_s
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    
    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect @user, event: :authentication
    else
      # 前
      #session["devise.#{provider}_data"] = request.env['omniauth.auth']
      redirect_to root_url
    end
  end

  def after_sign_in_path_for(resource)
    # sign_in_and_redirectの中でコールされる
    if Member.where(user_id: @user.id).exists?
      # 参加イベントがある
      events_url
    else
      # 完全新規
      events_add_url
    end
  end
end
