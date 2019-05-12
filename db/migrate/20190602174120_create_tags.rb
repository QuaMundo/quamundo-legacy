class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :tagset, array: true, null: false
      t.string :tagable_type
      t.integer :tagable_id
    end

    add_index :tags, :tagset, using: 'gin'
    add_index :tags, [:tagable_type, :tagable_id]
  end
end
