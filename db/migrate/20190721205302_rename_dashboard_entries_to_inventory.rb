class RenameDashboardEntriesToInventory < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute "ALTER VIEW dashboard_entries RENAME TO inventories;"
      end

      dir.down do
        execute "ALTER VIEW inventories RENAME TO dashboard_entries;"
      end
    end
  end
end
