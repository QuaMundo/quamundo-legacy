class RenameFigureNickToName < ActiveRecord::Migration[5.2]
  def change
    remove_index :figures, :nick
    rename_column :figures, :nick, :name
    remove_column :figures, :first_name
    remove_column :figures, :last_name
    add_index :figures, :name
  end
end
