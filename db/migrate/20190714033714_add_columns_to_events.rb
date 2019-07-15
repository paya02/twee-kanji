class AddColumnsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :date_list, :string
  end
end
