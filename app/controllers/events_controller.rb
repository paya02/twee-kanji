class EventsController < ApplicationController
  protect_from_forgery

  def show
    @event = Event.find(params[:id])
    @date_ary = @event.date_list.split(',')
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
          @member.user_id = @event.user_id
          @member.event_id = @event.id
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
end
