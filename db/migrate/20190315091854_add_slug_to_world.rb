class AddSlugToWorld < ActiveRecord::Migration[5.2]
  def change
    add_column :worlds, :slug, :string
  end
end
