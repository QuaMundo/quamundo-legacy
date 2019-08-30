class AddIndexesToSubjectRelativeRelationsAndRelationConstituents < ActiveRecord::Migration[6.0]
  def change
    # Indices for subject_relative_relations
    add_index :subject_relative_relations,
      [:relation_id, :subject_id],
      name: 'index_relation_subject_on_sub_rel_relations'
    add_index :subject_relative_relations,
      [:relation_id, :relative_id],
      name: 'index_relation_relative_on_sub_rel_relations'

    # Indices for relation_constituents
    add_index :relation_constituents,
      [:fact_constituent_id, :relation_id, :role],
      unique: true,
      name: 'index_fact_constituent_relation_role_unique_on_rel_constituents'
  end
end
