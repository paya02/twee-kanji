class EventsController < ApplicationController
  protect_from_forgery

  def show
    @event = Event.find(params[:id])

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
          @member.save!

          # 日程判定モデルの保存
          @event.date_list.split(',').each do |date|
            if !date.blank? then
              @decision = Decision.new
              @decision.event_id = @event.id
              @decision.user_id = @user.id
              @decision.day = Date.parse(date)
              @decision.save!
            end
          end
        end
      end
    end
    
    # メンバー
    @member = Member.where(event_id: @event.id).order(:id)
    # 日程(仮。後で日単位で可否別Countをselectしたい(列可変))
    @decisionDate = Decision.select('day, count(decisions.event_id) as count').where(event_id: @event.id).group(:day).order(:day)
    # 日別人別評価
    @decisionUser = Decision.where(event_id: @event.id).order(:day)
    
    # 可否ごとの件数をrelationで取得
    #@decisionSum = Decision.select('propriety, day, count(decisions.event_id) as proprietys_count').where(event_id: @event.id).group(:day, :propriety).order(:day, :propriety)
    #@event.detail = decisionSum[0].proprietys_count.to_s + '*' + decisionSum[0].day.strftime('%Y/%m/%d') + '*' + decisionSum[0].propriety.to_s
  end

  def add
    @date_cnt = APPSETTINGS::MAX_DATE_CNT
    @event = Event.new
  end

  def create
    if request.post? then
      # イベント・メンバーmodelを保存
      begin
        Event.transaction do
          @event = Event.new event_params
          # ログインユーザのイベントとして作成
          @event.user_id = current_user.id
          # 候補日付をカンマ区切りで保存
          @event.date_list = params[:date_val].join(',')
          @event.save!
          
          # 日程判定モデルの保存
          params[:date_val].each do |date|
            if !date.blank? then
              # ex)2019/08/17
              @decision = Decision.new
              @decision.event_id = @event.id
              @decision.user_id = @event.user_id
              @decision.day = Date.parse(date)
              @decision.save!
            end
          end
          
          # 幹事を参加メンバーに追加しておく
          @member = Member.new
          @member.event_id = @event.id
          @member.user_id = @event.user_id
          @member.save!
        end
        redirect_to action: 'show', id: @event.id
      rescue => exception
        redirect_to action: 'add'
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
