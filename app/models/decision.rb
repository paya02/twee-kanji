class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum propriety:{ ー: 0, ×: 1, △: 2, ○: 3}

  scope :decision_date_sum, ->(event_id) {
    sql = ""
    from = ""
    # 未入力のハイフンは除くので1から
    for i in 1..Decision.proprieties.length - 1
      # 最初のカンマは結合時に削除
      sql += ",'#{Decision.proprieties.keys[i]}', CASE d.propriety WHEN #{i} THEN d.data_cnt ELSE 0 END, ' '"

      # UNION->FROM部
      if from.empty? then
        from = "SELECT "
      else
        from += "UNION ALL SELECT "
      end
      from += "decisions.day AS day, COUNT(decisions.event_id) AS data_cnt, propriety AS propriety FROM decisions WHERE decisions.propriety = #{i} AND decisions.event_id = #{event_id} GROUP BY decisions.day "
    end
    sql = "SELECT d.day AS day, CONCAT(" + sql[1, sql.length] + ") AS proprieties_count "
    from = "FROM (" + from + ") AS d "
    find_by_sql(sql + from + "ORDER by d.day")
    }
end
