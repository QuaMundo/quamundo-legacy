class AddNickToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nick, :string, null: false
    add_index :users, :nick, unique: true
  end
end
