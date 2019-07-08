class CreateFactConstituents < ActiveRecord::Migration[5.2]
  def change
    create_table :fact_constituents do |t|
      t.string :roles, array: true, null: false, default: ['n.n.']
      t.string :constituable_type
      t.integer :constituable_id
      t.references :fact, foreign_key: true
    end

    add_index :fact_constituents, :roles, using: 'gin'
    add_index :fact_constituents,
      [:constituable_type, :constituable_id],
      name: 'index_fact_const_on_const_type_and_const_id'
    add_index :fact_constituents,
      [:constituable_type, :constituable_id, :fact_id],
      name: 'index_fact_const_on_const_type_and_const_id_and_fact_id',
      unique: true
  end
end
