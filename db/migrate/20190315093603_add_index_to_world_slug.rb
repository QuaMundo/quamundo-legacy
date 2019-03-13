class AddIndexToWorldSlug < ActiveRecord::Migration[5.2]
  def up
    # First create slugs where missing
    World.where(slug: nil).each do |world|
      slug = ActiveSupport::Inflector.parameterize(world.title)
      world.update_attributes!(slug: slug)
    end
    change_column :worlds, :slug, :string, null: false
    add_index :worlds, :slug, unique: true
  end

  def down
    remove_index :worlds, :slug
    remove_column :worlds, :slug
  end
end
