require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user1 = User.create(email: 'test@example.com', password: 123456, encrypted_password: 111)
    @user2 = User.create(email: 'test@example.com', password: 123456, encrypted_password: 111, uid: 'test_uid')
  end

  it "eメール、パスワードがあれば有効な状態であること" do
    expect(@user1).to be_valid
  end

  it "eメールがなければ無効な状態であること" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  # ソーシャルログインのみログイン許可しているので現状は問題なし
  it "パスワードがなければ無効な状態であること" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  describe "検索文字列に一致するuidの検索" do
    context "一致するとき" do
      it "検索文字列に一致するuidのユーザーを返すこと" do
        expect(User.uid('test_uid')).to include(@user2)
      end
    end
    context "一致しないとき" do
      it "検索文字列に一致しないとき、空のコレクションを返すこと" do
        expect(User.uid('aiueo')).to be_empty
      end
    end
  end
end
