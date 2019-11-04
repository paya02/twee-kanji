class ApplicationController < ActionController::Base

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, :notice => 'ログインすると機能を使えるようになります。'
    end
  end

  def event_member(event_id, user_id)
    unless Member.where(event_id: event_id, user_id: user_id).exists?
      redirect_to root_path, :notice => '閲覧する権限がありません。'
    end
  end

  def event_kanji(event_id, user_id)
    unless Event.where(id: event_id, user_id: user_id).exists?
      redirect_to root_path, :notice => '実行する権限がありません。'
    end
  end
end
