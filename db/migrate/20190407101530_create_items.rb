class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :world, foreign_key: true
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
