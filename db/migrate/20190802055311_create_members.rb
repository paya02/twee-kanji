class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.integer :event_id
      t.integer :user_id
      t.text :comment
      t.integer :vote

      t.timestamps
    end
  end
end
