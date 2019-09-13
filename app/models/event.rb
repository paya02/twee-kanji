class Event < ApplicationRecord
  has_many :decision, :dependent => :delete_all
  has_many :member, :dependent => :delete_all

  scope :event_list, ->(user_id) {
    sql = <<-EOS
    SELECT
      e.title AS title
    , e.event_on AS event_on
    , e.start_at AS start_at
    , e.ending_at AS ending_at
    , e.fee AS fee
    , e.detail AS detail
    , e.id
    , MIN(d.day) AS min_day
    , MAX(d.day) AS max_day
    FROM events e
    INNER JOIN decisions d
    ON e.id = d.event_id
    AND e.user_id = d.user_id
    WHERE
      e.user_id = #{user_id}
    GROUP BY
      e.title
    , e.event_on
    , e.start_at
    , e.ending_at
    , e.fee
    , e.detail
    , e.created_at
    , e.id
    , ifnull(e.event_on, str_to_date('1000-01-01', '%Y-%M-%d'))
    ORDER BY
      ifnull(e.event_on, str_to_date('1000-01-01', '%Y-%M-%d'))
    , MIN(d.day) DESC
    , e.created_at DESC
    , e.id DESC
    EOS
    find_by_sql(sql)
  }
end
