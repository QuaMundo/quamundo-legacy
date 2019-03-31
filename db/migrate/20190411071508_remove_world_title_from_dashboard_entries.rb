class RemoveWorldTitleFromDashboardEntries < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        # drop view if exist
        execute <<~SQL
          DROP VIEW IF EXISTS dashboard_entries;
        SQL

        # create view
        execute <<~SQL
          CREATE OR REPLACE VIEW dashboard_entries AS
            SELECT
              i.id AS inventory_id,
              'item' AS inventory_type,
              i.name AS name,
              i.description AS description,
              i.updated_at AS updated_at,
              wi.id AS world_id,
              wi.user_id AS user_id
            FROM items i
            LEFT JOIN worlds wi ON (wi.id = i.world_id)
            UNION SELECT
              f.id AS inventory_id,
              'figure' AS inventory_type,
              f.nick AS name,
              f.description AS description,
              f.updated_at AS updated_at,
              wf.id AS world_id,
              wf.user_id AS user_id
            FROM figures f
            LEFT JOIN worlds wf ON (wf.id = f.world_id)
          ORDER BY updated_at DESC;
        SQL
      end

      dir.down do
        # drop view if exist
        execute <<~SQL
          DROP VIEW IF EXISTS dashboard_entries;
        SQL

        # create view
        execute <<~SQL
          CREATE OR REPLACE VIEW dashboard_entries AS
            SELECT
              i.id AS inventory_id,
              'item' AS inventory_type,
              i.name AS name,
              i.description AS description,
              i.updated_at AS updated_at,
              wi.id AS world_id,
              wi.title AS world,
              wi.user_id AS user_id
            FROM items i
            LEFT JOIN worlds wi ON (wi.id = i.world_id)
            UNION SELECT
              f.id AS inventory_id,
              'figure' AS inventory_type,
              f.nick AS name,
              f.description AS description,
              f.updated_at AS updated_at,
              wf.id AS world_id,
              wf.title AS world,
              wf.user_id AS user_id
            FROM figures f
            LEFT JOIN worlds wf ON (wf.id = f.world_id)
          ORDER BY updated_at DESC;
        SQL
      end
    end
  end
end
