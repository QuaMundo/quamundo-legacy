class AddTimestampsToFactConstituents < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :fact_constituents, null: true

    ts = DateTime.now
    FactConstituent.update_all(created_at: ts, updated_at: ts)

    change_column_null :fact_constituents, :created_at, false
    change_column_null :fact_constituents, :updated_at, false
  end
end
