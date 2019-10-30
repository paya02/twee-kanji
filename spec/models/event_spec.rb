require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'イベントモデルのバリデーション' do
    it "feeがNULLの場合" do
      event = Event.create(
        user_id: 1,
        title: 'テストイベントのタイトル',
        fee: nil
      )
      expect(event).to be_valid
    end
    it "feeが数値の場合" do
      event = Event.create(
        user_id: 1,
        title: 'テストイベントのタイトル',
        fee: 0
      )
      expect(event).to be_valid
    end
  end
end
