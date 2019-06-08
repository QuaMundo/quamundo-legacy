class AddTimestampsToDossiers < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :dossiers, null: true

    ts = DateTime.now
    Dossier.update_all(created_at: ts, updated_at: ts)

    change_column_null :dossiers, :created_at, false
    change_column_null :dossiers, :updated_at, false
  end
end
