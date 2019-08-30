class CheckConstraintsForRelationConstituents < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # trigger/function to freeze relation constituent references
        execute <<~SQL
          CREATE FUNCTION freeze_relation_constituent_references() RETURNS TRIGGER AS $$
            BEGIN
              IF (OLD.relation_id != NEW.relation_id
                  OR OLD.fact_constituent_id != NEW.fact_constituent_id)
              THEN
                RAISE EXCEPTION 'References of a relation constituents may not be changed';
              ELSE
                RETURN NEW;
              END IF;
            END;
          $$ LANGUAGE plpgsql
        SQL

        execute <<~SQL
          CREATE TRIGGER relation_constituent_change
            BEFORE UPDATE OF fact_constituent_id, relation_id
              ON relation_constituents
                FOR EACH ROW EXECUTE PROCEDURE freeze_relation_constituent_references();
        SQL

        # trigger/function to esunre relation constuents belont to same fact
        execute <<~SQL
          CREATE FUNCTION relation_constituent_common_fact() RETURNS TRIGGER AS $$
            BEGIN
              IF ((SELECT COUNT(*) FROM (
                  SELECT DISTINCT fc.fact_id
                  FROM relation_constituents rc
                  JOIN fact_constituents fc ON rc.fact_constituent_id = fc.id
                  WHERE rc.relation_id = NEW.relation_id
                ) AS facts) > 1)
              THEN
                RAISE EXCEPTION 'Fact mismatch! All relation constituents must belong to the same fact';
              ELSE
                RETURN NEW;
              END IF;
            END;
          $$ LANGUAGE plpgsql
        SQL

        execute <<~SQL
          CREATE TRIGGER foreign_relation_constituent
            AFTER INSERT
              ON relation_constituents
                FOR EACH ROW EXECUTE PROCEDURE relation_constituent_common_fact();
        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER foreign_relation_constituent ON relation_constituents
        SQL

        # drop trigger
        execute <<~SQL
          DROP TRIGGER relation_constituent_change ON relation_constituents
        SQL

        # drop functions
        execute <<~SQL
          DROP FUNCTION relation_constituent_common_fact()
        SQL

        execute <<~SQL
          DROP FUNCTION freeze_relation_constituent_references()
        SQL
      end
    end
  end
end
