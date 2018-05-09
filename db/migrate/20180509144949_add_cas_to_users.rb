class AddCasToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :provider, :string, null: false
    add_column :users, :uid, :string, null: false

    add_index :users, :uid
    add_index :users, :provider
  end
end
