class HomesController < ApplicationController

  def index
  end

  def sample_login
    # サンプルユーザでログイン
    session[:user_id] = 21
    redirect_to events_url
  end
end
