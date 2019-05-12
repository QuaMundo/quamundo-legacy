class RemoveNotNullConstraintFromTagTagset < ActiveRecord::Migration[5.2]
  def up
    change_column :tags, :tagset, :string, array: true, default: []
    remove_index :tags, [:tagable_type, :tagable_id]
    add_index :tags, [:tagable_type, :tagable_id], unique: true

    # create tags for inventory which misses
    [World, Figure, Item, Location].each do |inventory|
      inventory.all.reject(&:tag).each { |i| i.create_tag }
    end
  end

  def down
    change_column :tags, :tagset, :string, array: true, null: false

    # delete tags with empty tagset
    Tag.where('tagset = ?', '{}').destroy_all

    remove_index :tags, [:tagable_type, :tagable_id]
    add_index :tags, [:tagable_type, :tagable_id]
  end
end
