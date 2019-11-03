FactoryBot.define do
  factory :user do
    email 'test@example.com'
    password 123456
    encrypted_password 111
  end
end
