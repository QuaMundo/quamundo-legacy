class CreateFigureAncestors < ActiveRecord::Migration[6.0]
  def change
    create_table :figure_ancestors do |t|
      t.references :figure, null: false, foreign_key: true
      t.references :ancestor, null: false, foreign_key: { to_table: :figures }
      t.string :name

      t.timestamps
    end
    add_index :figure_ancestors, [:figure_id, :ancestor_id], unique: true
  end
end
