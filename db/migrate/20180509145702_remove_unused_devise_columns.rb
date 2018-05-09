class RemoveUnusedDeviseColumns < ActiveRecord::Migration[5.1]
  def change
    # Remove Devise indices.
    remove_index :users, :reset_password_token

    # Remove Devise DBAuth columns.
    remove_column :users, :encrypted_password, :string, null: false, default: ''

    # Remove Devise Recoverable columns.
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime

    # Remove Devise Rememberable column.
    remove_column :users, :remember_created_at, :datetime

  end
end
