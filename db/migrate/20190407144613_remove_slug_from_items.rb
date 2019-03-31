class RemoveSlugFromItems < ActiveRecord::Migration[5.2]
  def change
    remove_index :items, :slug
    remove_column :items, :slug
  end
end
