require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "eメール、パスワードがあれば有効な状態であること" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "eメールがなければ無効な状態であること" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  # ソーシャルログインのみログイン許可しているので現状は問題なし
  it "パスワードがなければ無効な状態であること" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  describe "検索文字列に一致するuidの検索" do
    context "一致するとき" do
      it "検索文字列に一致するuidのユーザーを返すこと" do
        user = FactoryBot.create(:user, uid: 'test_uid')
        expect(User.uid('test_uid')).to include(user)
      end
    end
    context "一致しないとき" do
      it "検索文字列に一致しないとき、空のコレクションを返すこと" do
        expect(User.uid('aiueo')).to be_empty
      end
    end
  end
end
