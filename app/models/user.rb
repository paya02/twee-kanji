class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  
  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    
    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        encrypted_password: Devise.friendly_token[0, 20],
        username: auth.info.name,
        nickname: auth.info.nickname
        )
    end

    user
  end

  # ログイン保持チェックボックスを非表示にしたので記憶
  def remember_me
    true
  end

  # パスワード入力は不要なので、ソーシャルログイン以外(未実装)の場合だけチェック
  def password_required?
    super && provider.blank?
  end

  private
  
  # ダミーのアドレスを用意
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
