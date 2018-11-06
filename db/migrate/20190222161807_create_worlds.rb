class CreateWorlds < ActiveRecord::Migration[5.2]
  def change
    create_table :worlds do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
