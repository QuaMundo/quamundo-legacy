class AddTimestampsToNotes < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :notes, null: true

    ts = DateTime.now
    Note.update_all(created_at: ts, updated_at: ts)

    change_column_null :notes, :created_at, false
    change_column_null :notes, :updated_at, false
  end
end
