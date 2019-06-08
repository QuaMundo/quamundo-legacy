class CreateDossiers < ActiveRecord::Migration[5.2]
  def change
    create_table :dossiers do |t|
      t.string :title, null: false
      t.text :description
      t.text :content, null: false
      t.string :dossierable_type
      t.integer :dossierable_id
    end

    add_index :dossiers, [:dossierable_type, :dossierable_id]
  end
end
