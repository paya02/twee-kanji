class AddColumnsToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :uid, :string
  end
end
