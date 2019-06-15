class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :username, :string
    add_column :users, :nickname, :string
    remove_index :users, column: [:email]
    remove_index :users, column: [:reset_password_token]
    add_index :users, [:provider, :uid], unique: true
  end
end
