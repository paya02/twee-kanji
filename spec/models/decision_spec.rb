require 'rails_helper'

RSpec.describe Decision, type: :model do
  it "判定モデルのバリデーション" do
    decision = Decision.create(
      event_id: 1,
      user_id: 1,
      day: Date.today
    )
    expect(decision).to be_valid
  end
end
