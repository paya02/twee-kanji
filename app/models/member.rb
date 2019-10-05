class Member < ApplicationRecord
  belongs_to :user
  belongs_to :event

  # validates
  validates :event_id, presence: true
  validates :user_id, presence: true

  scope :event_id, ->(event_id) { where("event_id = ?", event_id) }
  scope :user_id, ->(user_id) { where("user_id = ?", user_id) }
  scope :uid, ->(uid) { where("uid = ?", uid) }
end
