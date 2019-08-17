class EventsController < ApplicationController
  protect_from_forgery

  def show
    @event = Event.find(params[:id])
    @date_ary = @event.date_list.split(',')

    # TwitterAPI使用準備
    client = twitter_configuration

    kanji = User.find(@event.user_id)
    options = { count: 100 }
    # 幹事ユーザのリスト取得
    @owned_lists = client.owned_lists(kanji.nickname, options)
    # リスト選択時は、リストユーザをメンバーに加えてから表示
    if params[:list] then
      client.list_members(kanji.nickname, params[:list]).each do |list|
        @user = User.find_for_member(list)
        if !Member.event_id(@event.id).user_id(@user.id).exists?
          # まだメンバーでないユーザがいたら、メンバーを追加する
          @member = Member.new
          @member.event_id = @event.id
          @member.user_id = @user.id
          @member.uid = list.id
          @member.save!
          # @event.detail += @user.nickname + ','
          # @event.detail += @user.id.to_s + ','
        end
      end
    end
    
    # 日程調整メンバー
    @member = Member.where(event_id: @event.id)
  end

  def add
    @date_cnt = APPSETTINGS::MAX_DATE_CNT
    @event = Event.new
  end

  def create
    if request.post? then
      @event = Event.new event_params
      @member = Member.new

      # ログインユーザのイベントとして作成
      @event.user_id = current_user.id
      # 候補日付をカンマ区切りで保存
      csv_date = ""
      params[:date_val].each do |date|
        csv_date += date + ','
      end
      @event.date_list = csv_date

      # イベント・メンバーmodelを保存
      begin
        Event.transaction do
          @event.save!
          # 幹事を参加メンバーに追加しておく
          @member.event_id = @event.id
          @member.user_id = @event.user_id
          @member.uid = current_user.uid
          @member.save!
        end
        redirect_to action: 'show', id: @event.id
      rescue => exception
        render 'add'        
      end

    end
  end

  def edit
  end

  private
  def event_params
    params.require(:event).permit(:title, :url, :fee, :detail, date_val: [])
  end

  def twitter_configuration
    return client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:twitter_api_key]
      config.consumer_secret     = Rails.application.credentials.twitter[:twitter_api_secret]
      config.access_token        = Rails.application.credentials.twitter[:twitter_access_key]
      config.access_token_secret = Rails.application.credentials.twitter[:twitter_access_secret]
    end
  end
end
