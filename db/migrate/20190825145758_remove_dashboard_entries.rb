class RemoveDashboardEntries < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<~EOSQL
          DROP VIEW IF EXISTS public.dashboard_entries
        EOSQL
      end

      dir.down do
      end
    end
  end
end
