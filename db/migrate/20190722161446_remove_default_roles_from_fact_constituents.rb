class RemoveDefaultRolesFromFactConstituents < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:fact_constituents, :roles,
                          from: ['n.n.'], to: [])
  end
end
