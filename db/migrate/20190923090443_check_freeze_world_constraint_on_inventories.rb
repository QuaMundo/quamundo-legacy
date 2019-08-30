class CheckFreezeWorldConstraintOnInventories < ActiveRecord::Migration[6.0]
  # check on db layer the reference to a world cannot be changed
  def change
    reversible do |dir|
      dir.up do
        # create the trigger function
        execute <<~SQL
          CREATE OR REPLACE FUNCTION freeze_world_ref() RETURNS TRIGGER AS $$
            BEGIN
              IF NEW.world_id != OLD.world_id THEN
                RAISE EXCEPTION 'Not allowed to change world reference of %',
                TG_TABLE_NAME;
              END IF;
              RETURN NEW;
            END;
          $$ language plpgsql;
        SQL

        # create triggers
        execute <<~SQL
          CREATE TRIGGER item_world_change BEFORE UPDATE OF world_id
            ON items
              FOR EACH ROW EXECUTE PROCEDURE freeze_world_ref();
        SQL

        execute <<~SQL
          CREATE TRIGGER figure_world_change BEFORE UPDATE OF world_id
            ON figures
              FOR EACH ROW EXECUTE PROCEDURE freeze_world_ref();
        SQL

        execute <<~SQL
          CREATE TRIGGER concept_world_change BEFORE UPDATE OF world_id
            ON concepts
              FOR EACH ROW EXECUTE PROCEDURE freeze_world_ref();
        SQL

        execute <<~SQL
          CREATE TRIGGER location_world_change BEFORE UPDATE OF world_id
            ON locations
              FOR EACH ROW EXECUTE PROCEDURE freeze_world_ref();
        SQL

        execute <<~SQL
          CREATE TRIGGER fact_world_change BEFORE UPDATE OF world_id
            ON facts
              FOR EACH ROW EXECUTE PROCEDURE freeze_world_ref();
        SQL
      end

      dir.down do
        # drop triggers
        execute <<~SQL
          DROP TRIGGER item_world_change on items;
        SQL

        execute <<~SQL
          DROP TRIGGER figure_world_change on figures;
        SQL

        execute <<~SQL
          DROP TRIGGER concept_world_change on concepts;
        SQL

        execute <<~SQL
          DROP TRIGGER location_world_change on locations;
        SQL

        execute <<~SQL
          DROP TRIGGER fact_world_change on facts;
        SQL

        execute <<~SQL
          DROP FUNCTION freeze_world_ref();
        SQL

      end
    end
  end
end
