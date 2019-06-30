class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.date :event_on
      t.time :start_at
      t.time :ending_at
      t.text :url
      t.integer :fee
      t.text :detail

      t.timestamps
    end
  end
end
