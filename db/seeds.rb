# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
  email: 'test_twitter@example.com',
  encrypted_password: 'test123',
  reset_password_token: 'test',
  reset_password_sent_at: nil,
  remember_created_at: nil,
  provider: 'twitter',
  uid: 'test_twitter1234567890',
  username: 'TestTwitterUser',
  nickname: 'test_twitter_user'
)
