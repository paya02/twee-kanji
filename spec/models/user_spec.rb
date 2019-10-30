require 'rails_helper'

RSpec.describe User, type: :model do
  it "ユーザモデルのバリデーション" do
    user = User.create(
      email: 'test@example.com',
      password: 123456,
      encrypted_password: 111
    )
    expect(user).to be_valid
  end

end
