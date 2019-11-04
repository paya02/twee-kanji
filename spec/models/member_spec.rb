require 'rails_helper'

RSpec.describe Member, type: :model do
  it "メンバーモデルのバリデーション" do
    member = Member.create(
      event_id: 1,
      user_id: 1
    )
    expect(member).to be_valid
  end

end
