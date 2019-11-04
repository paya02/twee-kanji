require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  
  describe "#index" do
    context "認証済みのユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it "200レスポンスを返すこと" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        get :index
        expect(response).to have_http_status "302"
      end
      
      it "トップページにリダイレクトすること" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "認証済みのユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
      end
      
      it "プロジェクトを追加できること" do
        sign_in @user
        event_params = FactoryBot.attributes_for(:event, user_id: @user.id)
        date_val_params = ['2019/01/01','2019/01/02']
        expect {
          post :create, params: { event: event_params, date_val: date_val_params}
        }.to change(Event, :count).by(1)
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        event_params = FactoryBot.attributes_for(:event)
        date_val_params = ['2019/01/01','2019/01/02']
        post :create, params: { event: event_params, date_val: date_val_params }
        expect(response).to have_http_status "302"
      end

      it "トップページにリダイレクトすること" do
        event_params = FactoryBot.attributes_for(:event)
        date_val_params = ['2019/01/01','2019/01/02']
        post :create, params: { event: event_params, date_val: date_val_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    context "認可されたユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, user_id: @user.id)
        @member = FactoryBot.create(:member, event_id: @event.id, user_id: @user.id)
      end

      it "プロジェクトを更新できること" do
        sign_in @user
        event_params = FactoryBot.attributes_for(:event, title: "New Project Name")
        date_val_params = ['2019/01/01','2019/01/02']
        patch :update, params: { id: @event.id, event: event_params, date_val: date_val_params }
        expect(@event.reload.title).to eq "New Project Name"
      end
    end

    context "認可されていないユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, user_id: other_user.id, title: "Same Old Name")
        @member = FactoryBot.create(:member, event_id: @event.id, user_id: other_user.id)
      end

      it "プロジェクトを更新できないこと" do
        sign_in @user
        event_params = FactoryBot.attributes_for(:event, title: "New Name")
        patch :update, params: { id: @event.id, event: event_params }
        expect(@event.reload.title).to eq "Same Old Name"
      end

      it "トップページにリダイレクトすること" do
        sign_in @user
        event_params = FactoryBot.attributes_for(:event)
        patch :update, params: { id: @event.id, event: event_params }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, user_id: @user.id)
      end

      it "302レスポンスを返すこと" do
        event_params = FactoryBot.attributes_for(:event)
        date_val_params = ['2019/01/01','2019/01/02']
        patch :update, params: { id: @event.id, event: event_params, date_val: date_val_params }
        expect(response).to have_http_status "302"
      end

      it "トップページにリダイレクトすること" do
        event_params = FactoryBot.attributes_for(:event)
        date_val_params = ['2019/01/01','2019/01/02']
        patch :update, params: { id: @event.id, project: event_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    context "認可されたユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, user_id: @user.id)
      end

      it "プロジェクトを削除できること" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @event.id }
        }.to change(Event, :count).by(-1)
      end
    end

    context "認可されていないユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, user_id: other_user.id)
      end

      it "プロジェクトを削除できないこと" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @event.id }
        }.to_not change(Event, :count)
      end

      it "トップページにリダイレクトすること" do
        sign_in @user
        delete :destroy, params: { id: @event.id }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, user_id: @user.id)
      end

      it "302レスポンスを返すこと" do
        delete :destroy, params: { id: @event.id }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        delete :destroy, params: { id: @event.id }
        expect(response).to redirect_to root_path
      end

      it "プロジェクトを削除できないこと" do
        expect {
          delete :destroy, params: { id: @event.id }
        }.to_not change(Event, :count)
      end
     end
  end
end
