class RemoveFactsFromInventories < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # drop index
        remove_index :inventories, [:inventory_id, :inventory_type]

        # drop trigger concepts
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_concept_inventories ON concepts;
        SQL

        # drop trigger figures
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_figure_inventories ON figures;
        SQL

        # drop trigger facts
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_fact_inventories ON facts;
        SQL

        # drop trigger items
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_item_inventories ON items;
        SQL

        # drop trigger locations
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_location_inventories ON locations;
        SQL

        # drop refresh function
        execute <<~SQL
          DROP FUNCTION IF EXISTS refresh_inventories;
        SQL

        # drop view if exist
        execute <<~SQL
          DROP MATERIALIZED VIEW IF EXISTS inventories;
        SQL

        # create view
        execute <<~SQL
          CREATE MATERIALIZED VIEW inventories AS
            SELECT
              i.id AS inventory_id,
              'Item' AS inventory_type,
              i.name AS name,
              i.description AS description,
              i.updated_at AS updated_at,
              wi.id AS world_id
            FROM items i
            LEFT JOIN worlds wi ON (wi.id = i.world_id)
            UNION SELECT
              f.id AS inventory_id,
              'Figure' AS inventory_type,
              f.name AS name,
              f.description AS description,
              f.updated_at AS updated_at,
              wf.id AS world_id
            FROM figures f
            LEFT JOIN worlds wf ON (wf.id = f.world_id)
            UNION SELECT
              l.id AS inventory_id,
              'Location' AS inventory_type,
              l.name AS name,
              l.description AS description,
              l.updated_at AS updated_at,
              wl.id AS world_id
            FROM locations l
            LEFT JOIN worlds wl ON (wl.id = l.world_id)
            UNION SELECT
              c.id AS inventory_id,
              'Concept' AS inventory_type,
              c.name AS name,
              c.description AS description,
              c.updated_at AS updated_at,
              wc.id AS world_id
            FROM concepts c
            LEFT JOIN worlds wc ON (wc.id = c.world_id)
          ORDER BY updated_at DESC
          WITH DATA;
        SQL

        # Refresh function
        execute <<~SQL
          CREATE FUNCTION refresh_inventories()
          RETURNS trigger AS $function$
            BEGIN
              REFRESH MATERIALIZED VIEW inventories;
              RETURN NULL;
            END;
          $function$ LANGUAGE plpgsql;
        SQL

        # Trigger for concepts
        execute <<~SQL
          CREATE TRIGGER refresh_concept_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON concepts FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for facts
        execute <<~SQL
          CREATE TRIGGER refresh_fact_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON facts FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for figures
        execute <<~SQL
          CREATE TRIGGER refresh_figure_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON figures FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for items
        execute <<~SQL
          CREATE TRIGGER refresh_item_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON items FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for locations
        execute <<~SQL
          CREATE TRIGGER refresh_location_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON locations FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # create index
        add_index :inventories, [:inventory_id, :inventory_type]

        # refresh view initally
        execute <<~SQL
          REFRESH MATERIALIZED VIEW inventories;
        SQL
      end

      dir.down do
        # drop index
        remove_index :inventories, [:inventory_id, :inventory_type]

        # drop trigger concepts
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_concept_inventories ON concepts;
        SQL

        # drop trigger figures
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_figure_inventories ON figures;
        SQL

        # drop trigger facts
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_fact_inventories ON facts;
        SQL

        # drop trigger items
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_item_inventories ON items;
        SQL

        # drop trigger locations
        execute <<~SQL
          DROP TRIGGER IF EXISTS refresh_location_inventories ON locations;
        SQL

        # drop refresh function
        execute <<~SQL
          DROP FUNCTION IF EXISTS refresh_inventories;
        SQL

        # drop view if exist
        execute <<~SQL
          DROP MATERIALIZED VIEW IF EXISTS inventories;
        SQL

        # drop view if exist
        execute <<~SQL
          DROP VIEW IF EXISTS inventories;
        SQL

        # create view
        execute <<~SQL
          CREATE MATERIALIZED VIEW inventories AS
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
              f.name AS name,
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
            UNION SELECT
              fa.id AS inventory_id,
              'Fact' AS inventory_type,
              fa.name AS name,
              fa.description AS description,
              fa.updated_at AS updated_at,
              wfa.id AS world_id,
              wfa.user_id AS user_id
            FROM facts fa
            LEFT JOIN worlds wfa ON (wfa.id = fa.world_id)
            UNION SELECT
              c.id AS inventory_id,
              'Concept' AS inventory_type,
              c.name AS name,
              c.description AS description,
              c.updated_at AS updated_at,
              wc.id AS world_id,
              wc.user_id AS user_id
            FROM concepts c
            LEFT JOIN worlds wc ON (wc.id = c.world_id)
          ORDER BY updated_at DESC;
        SQL

        # Refresh function
        execute <<~SQL
          CREATE FUNCTION refresh_inventories()
          RETURNS trigger AS $function$
            BEGIN
              REFRESH MATERIALIZED VIEW inventories;
              RETURN NULL;
            END;
          $function$ LANGUAGE plpgsql;
        SQL

        # Trigger for concepts
        execute <<~SQL
          CREATE TRIGGER refresh_concept_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON concepts FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for facts
        execute <<~SQL
          CREATE TRIGGER refresh_fact_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON facts FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for figures
        execute <<~SQL
          CREATE TRIGGER refresh_figure_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON figures FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for items
        execute <<~SQL
          CREATE TRIGGER refresh_item_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON items FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # Trigger for locations
        execute <<~SQL
          CREATE TRIGGER refresh_location_inventories
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON locations FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_inventories();
        SQL

        # create index
        add_index :inventories, [:inventory_id, :inventory_type]

        # refresh view initally
        execute <<~SQL
          REFRESH MATERIALIZED VIEW inventories;
        SQL
      end
    end
  end
end
