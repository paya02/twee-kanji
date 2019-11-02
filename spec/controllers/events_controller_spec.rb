require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  
  describe "#index" do
    context "認証済みのユーザーとして" do
      before do
        @user_i = User.create(email: 'test@example.com', password: 123456, encrypted_password: 111)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user_i
        get :index
        expect(response).to be_success
      end

      it "200レスポンスを返すこと" do
        sign_in @user_i
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

  # describe "#create" do
  #   context "認証済みのユーザーとして" do
  #     before do
  #       @user_c = User.create(email: 'test@example.com', password: 123456, encrypted_password: 111)
  #     end

  #     it "プロジェクトを追加できること" do
  #     end
  #   end
  # end
end
