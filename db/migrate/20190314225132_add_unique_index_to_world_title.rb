class AddUniqueIndexToWorldTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :worlds, :title, unique: true
  end
end
