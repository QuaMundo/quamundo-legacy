class CreateTraits < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'hstore' unless extension_enabled? 'hstore'

    create_table :traits do |t|
      t.hstore :attributeset, null: false, default: {}
      t.string :traitable_type
      t.integer :traitable_id
    end

    add_index :traits, :attributeset, using: 'gin'
    add_index :traits, [:traitable_type, :traitable_id], unique: true

    # Create traits for inventory which misses
    [World, Figure, Item, Location].each do |inventory|
      inventory.all.reject(&:trait).each { |i| i.create_trait }
    end
  end
end
