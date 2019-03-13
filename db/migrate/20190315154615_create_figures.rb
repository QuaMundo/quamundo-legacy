class CreateFigures < ActiveRecord::Migration[5.2]
  def change
    create_table :figures do |t|
      t.string :first_name
      t.string :last_name
      t.string :nick, null: false
      t.text :description
      t.references :world, foreign_key: true

      t.timestamps
    end
    add_index :figures, :nick, unique: true
  end
end
