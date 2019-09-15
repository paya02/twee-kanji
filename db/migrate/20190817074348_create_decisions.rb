class CreateDecisions < ActiveRecord::Migration[5.2]
  def change
    create_table :decisions do |t|
      t.integer :event_id
      t.integer :user_id
      t.date :day
      t.integer :propriety, default: 0

      t.timestamps
    end
  end
end
