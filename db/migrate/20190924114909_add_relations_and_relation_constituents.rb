class AddRelationsAndRelationConstituents < ActiveRecord::Migration[6.0]
  def change
    create_table :relations do |t|
      t.string  :name, null: false
      t.string  :reverse_name
      t.text    :description
      t.timestamps
    end

    create_table :relation_constituents do |t|
      t.references :fact_constituent, null: false
      t.references :relation, null: false
      t.column :role, :relation_role, null: false
    end

    add_index :relation_constituents,
      [:relation_id, :role],
      name: 'index_rel_const_on_relation_and_role'
    add_index :relation_constituents,
      [:fact_constituent_id, :role],
      name: 'index_rel_const_on_fact_const_and_role'
  end
end

