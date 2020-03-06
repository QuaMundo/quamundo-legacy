class AddUniqueIndexForSubjectRelativeRelationsOnSubjectIdAndRelativeId < ActiveRecord::Migration[6.0]
  def change
    add_index :subject_relative_relations,
      [:subject_id, :relative_id],
      name: 'unique_index_subject_relative_on_sub_rel_relations',
      unique: true
  end
end
