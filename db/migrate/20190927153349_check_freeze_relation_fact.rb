class CheckFreezeRelationFact < ActiveRecord::Migration[6.0]
  # check on db layer the fact of a relation cannot be changed
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE FUNCTION freeze_relation_fact() RETURNS TRIGGER AS $$
            BEGIN
              IF (NEW.fact_id != OLD.fact_id)
              THEN
                RAISE EXCEPTION 'Referenced fact cannot be changed!';
              END IF;
              RETURN NEW;
            END;
          $$ LANGUAGE plpgsql;
        SQL

        execute <<~SQL
          CREATE TRIGGER relation_fact_change
            BEFORE UPDATE OF fact_id ON relations
              FOR EACH ROW EXECUTE PROCEDURE freeze_relation_fact();
        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER relation_fact_change ON relations;
        SQL

        execute <<~SQL
          DROP FUNCTION freeze_relation_fact();
        SQL
      end
    end
  end
end
