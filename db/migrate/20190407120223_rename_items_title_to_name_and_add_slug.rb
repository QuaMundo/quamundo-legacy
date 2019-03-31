class RenameItemsTitleToNameAndAddSlug < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :title, :name
    add_column :items, :slug, :string, null: false
    add_index :items, :slug, unique: true
  end
end
