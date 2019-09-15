class EventsController < ApplicationController
  protect_from_forgery

  def index
    # ログインユーザのイベント取得
    @event = Event.event_list(current_user.id)
  end

  def create
    if request.post? then
      # イベント・メンバーmodelを保存
      begin
        Event.transaction do
          @event = Event.new event_params
          # ログインユーザのイベントとして作成
          @event.user_id = current_user.id
          @event.save!
          
          # 重複削除して日程判定モデルの保存
          date_list = params[:date_val].uniq
          date_list.each do |date|
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

  def show
    @event = Event.find(params[:id])
    # 日程
    @decisionDate = Decision.select(:day).where(event_id: @event.id).group(:day).order(:day)

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
          @decisionDate.each do |decision|
            @decision = Decision.new
            @decision.event_id = @event.id
            @decision.user_id = @user.id
            @decision.day = decision.day
            @decision.save!
          end
        end
      end
    end
    
    # メンバー
    @member = Member.where(event_id: @event.id).order(:id)
    # 日別人別評価
    @decisionUser = Decision.where(event_id: @event.id).order(:day)
    # 可否ごとの件数をrelationで取得
    @decisionDateSum = Decision.decision_date_sum(@event.id)
    # ログイン中のユーザID(User)
    @current_user_id = current_user.id
    # リストボックスの選択肢
    @proprieties_for_options = Decision.proprieties
  end

  def adjustment
    if request.post? then
      @event = Event.find(params[:id])
      @decisionDateUser = Decision.where(event_id: @event.id, user_id: current_user.id).order(:day)
      # 対象の日付とパラメータの個数が一致することを確認
      if params[:propriety].length == @decisionDateUser.length then
        # ログイン中ユーザの評価を更新
        params[:propriety].zip(@decisionDateUser) do |propriety, decision| 
          #Decision.find_for_save() 後で消して
          decision.propriety = propriety.to_i
          decision.save!
        end
        redirect_to action: 'show', id: params[:id]
      else
        # 値が不正ですのエラーメッセージ
      end
      
      # @decisionDateUser.each do |date|
      #   if date.day.strftime('%Y/%m/%d') = 
      # end
      #render html: params[:propriety].length.to_s + '@' + @decisionDateUser.length.to_s
    end
  end

  def add
    @date_cnt = APPSETTINGS::MAX_DATE_CNT
    @event = Event.new
  end

  def edit
    @date_cnt = APPSETTINGS::MAX_DATE_CNT
    @event = Event.find(params[:id])
    # 日程
    @decisionDate = Decision.date(@event.id)
  end

  def update
    if request.patch? then
      @event = Event.find(params[:id])
      # 日付リストの取得
      date_list = params[:date_val].uniq
      params = event_params
      begin
        Event.transaction do
          # イベント情報の更新
          @event.update_attributes!(title: params[:title], url: params[:url], fee: params[:fee], detail: params[:detail])
          # 日程の追加削除判定
        end
        redirect_to action: 'show', id: @event.id
      rescue => exception
        # エラー処理
        redirect_to action: 'edit', id: @event.id
      end
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "イベントを削除しました"
    redirect_to action: 'index'
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
