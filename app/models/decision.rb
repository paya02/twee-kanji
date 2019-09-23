class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum propriety:{ ー: 0, ×: 1, △: 2, ○: 3}

  scope :date, ->(event_id) {
    Decision.select(:day).where(event_id: event_id).group(:day).order(:day)
  }

  scope :decision_date_sum, ->(event_id) {
    # 件数取得部
    cnt = ""
    for i in 1..Decision.proprieties.length - 1
      cnt += ",'#{Decision.proprieties.keys[i]}', (SELECT COUNT(s.event_id) FROM decisions s WHERE s.event_id = d.event_id AND s.day = d.day AND s.propriety = #{i}), ' '"
    end
    cnt = cnt[1, cnt.length]

    sql = <<-EOS
    SELECT d.day AS day
    , CONCAT(#{cnt}) AS proprieties_count
    FROM decisions d
    WHERE
      d.event_id = #{event_id}
    GROUP BY
      d.day
    ORDER BY
      d.day 
    EOS
    find_by_sql(sql)
  }

  # def self.find_for_save(user_id, day, )
  #   user = User.where(uid: auth.uid, provider: auth.provider).first
  # end
end