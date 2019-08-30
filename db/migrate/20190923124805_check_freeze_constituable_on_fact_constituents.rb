class CheckFreezeConstituableOnFactConstituents < ActiveRecord::Migration[6.0]
  # check on db layer the constituable of a fact constitunent cannot
  # be changed
  def change
    reversible do |dir|
      dir.up do
        # create trigger function
        execute <<~SQL
          CREATE FUNCTION freeze_fact_constituent_constituable() RETURNS TRIGGER AS $$
            BEGIN
              IF (NEW.constituable_id != OLD.constituable_id
                  OR NEW.constituable_type != OLD.constituable_type)
              THEN
                RAISE EXCEPTION 'Referenced inventory of fact constituent cannot be changed';
              END IF;
              RETURN NEW;
            END;
          $$ LANGUAGE plpgsql;
        SQL

        # create trigger
        execute <<~SQL
          CREATE TRIGGER fact_constituent_change
            BEFORE UPDATE OF constituable_id, constituable_type
              ON fact_constituents
                FOR EACH ROW EXECUTE PROCEDURE freeze_fact_constituent_constituable();
        SQL
      end

      dir.down do
        # drop trigger
        execute <<~SQL
          DROP TRIGGER fact_constituent_change ON fact_constituents;
        SQL

        # drop function
        execute <<~SQL
          DROP FUNCTION freeze_fact_constituent_constituable();
        SQL
      end
    end
  end
end
