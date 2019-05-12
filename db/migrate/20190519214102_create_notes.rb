class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.text :content, null: false
      t.string :noteable_type
      t.integer :noteable_id
    end

    add_index :notes, [:noteable_type, :noteable_id]
  end
end
