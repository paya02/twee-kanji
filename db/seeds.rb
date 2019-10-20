# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User ---------------------------------
User.create!(
  email: 'test_twitter@example.com',
  encrypted_password: 'test123',
  reset_password_token: 'test',
  reset_password_sent_at: nil,
  remember_created_at: nil,
  provider: 'twitter',
  uid: 'sample_kanji_user',
  username: 'サンプル幹事',
  nickname: 'twi-kanji_sample'
)

(1..3).each do |cnt|
  User.create!(
    email: "test_twitter#{cnt.to_s}@example.com",
    encrypted_password: 'test123',
    reset_password_token: 'test',
    reset_password_sent_at: nil,
    remember_created_at: nil,
    provider: 'twitter',
    uid: 'sample_memver_user' + cnt.to_s,
    username: 'サンプル参加者' + cnt.to_s,
    nickname: 'sample_user' + cnt.to_s
  )
end

# event ---------------------------------
Event.create!(
  user_id: 1,
  title: 'サンプルイベント', 
  detail: 'サンプルイベントの詳細です。参加者の方により詳細なイベントの情報を伝えることができます。' 
);

# member ---------------------------------
Member.create!(
  event_id: 1,
  user_id: 1
);

# decisions ---------------------------------
(5..7).each do |cnt|
  Decision.create!(
    event_id: 1,
    user_id: 1,
    day: Date.parse("2019/10/2" + cnt.to_s)
  );
end