class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  has_many :member
  has_many :decision
  scope :uid, ->(uid) { where("uid = ?", uid) }

  # ログイン時の存在チェック＆ユーザ追加
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

  # メンバー追加時のチェック＄ユーザ追加
  def self.find_for_member(list)
    user = User.where(uid: list.id, provider: 'twitter').first
    
    unless user
      user = User.create!(
        uid:      list.id,
        provider: 'twitter',
        email:    'twitter@example.com',
        encrypted_password: 111,
        username: list.name,
        nickname: list.screen_name
        )
    end

    user
  end

  private
  
  # ダミーのアドレスを用意
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  # emailのバリデーション無効
  def email_required?
    false
  end
  def email_changed?
    false
  end
  def will_save_change_to_email?
    false
  end
  # ログイン保持チェックボックスを非表示にしたので記憶
  def remember_me
    true
  end

  # パスワード入力は不要なので、ソーシャルログイン以外(未実装)の場合だけチェック
  def password_required?
    super && provider.blank?
  end
end
