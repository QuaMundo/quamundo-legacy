class AddLocationsToDashboard < ActiveRecord::Migration[5.2]
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
              'Item' AS inventory_type,
              i.name AS name,
              i.description AS description,
              i.updated_at AS updated_at,
              wi.id AS world_id,
              wi.user_id AS user_id
            FROM items i
            LEFT JOIN worlds wi ON (wi.id = i.world_id)
            UNION SELECT
              f.id AS inventory_id,
              'Figure' AS inventory_type,
              f.nick AS name,
              f.description AS description,
              f.updated_at AS updated_at,
              wf.id AS world_id,
              wf.user_id AS user_id
            FROM figures f
            LEFT JOIN worlds wf ON (wf.id = f.world_id)
            UNION SELECT
              l.id AS inventory_id,
              'Location' AS inventory_type,
              l.name AS name,
              l.description AS description,
              l.updated_at AS updated_at,
              wl.id AS world_id,
              wl.user_id AS user_id
            FROM locations l
            LEFT JOIN worlds wl ON (wl.id = l.world_id)
          ORDER BY updated_at DESC;
        SQL
      end

      dir.down do |dir|
        # drop view if exist
        execute <<~SQL
          DROP VIEW IF EXISTS dashboard_entries;
        SQL

        # create view
        execute <<~SQL
          CREATE OR REPLACE VIEW dashboard_entries AS
            SELECT
              i.id AS inventory_id,
              'Item' AS inventory_type,
              i.name AS name,
              i.description AS description,
              i.updated_at AS updated_at,
              wi.id AS world_id,
              wi.user_id AS user_id
            FROM items i
            LEFT JOIN worlds wi ON (wi.id = i.world_id)
            UNION SELECT
              f.id AS inventory_id,
              'Figure' AS inventory_type,
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
    end
  end
end
