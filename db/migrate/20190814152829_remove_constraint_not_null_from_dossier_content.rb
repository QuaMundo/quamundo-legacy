class RemoveConstraintNotNullFromDossierContent < ActiveRecord::Migration[5.2]
  def change
    change_column_null :dossiers, :content, true
  end
end
