class ChangeDatatypeId < ActiveRecord::Migration[5.2]
  def change
    # members
    change_column :members, :event_id, :bigint
    change_column :members, :user_id, :bigint
    # events
    change_column :events, :user_id, :bigint
    # decisions
    change_column :decisions, :event_id, :bigint
    change_column :decisions, :user_id, :bigint
  end
end
