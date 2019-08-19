class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum propriety:{ ー: 0, ×: 1, △: 2, ○: 3}
end
