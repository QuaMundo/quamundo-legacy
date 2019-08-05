class CreateConcepts < ActiveRecord::Migration[5.2]
  def change
    create_table :concepts do |t|
      t.string  :name, null: false
      t.text    :description
      t.references :world, foreign_key: true

      t.timestamps
    end
  end
end
