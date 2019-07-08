class AddConstraintNotNullToFactConstituentsConstituable < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:fact_constituents, :constituable_type, false)
    change_column_null(:fact_constituents, :constituable_id, false)
  end
end
