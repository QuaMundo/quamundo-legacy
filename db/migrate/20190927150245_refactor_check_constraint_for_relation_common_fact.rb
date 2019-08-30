class RefactorCheckConstraintForRelationCommonFact < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # remove old trigger and function
        execute <<~SQL
          DROP TRIGGER foreign_relation_constituent ON relation_constituents
        SQL

        execute <<~SQL
          DROP FUNCTION relation_constituent_common_fact()
        SQL

        # add new function and trigger
        execute <<~SQL
          CREATE FUNCTION relation_constituent_common_fact() RETURNS TRIGGER AS $$
            BEGIN
              IF (
                (SELECT fact_id FROM relations WHERE id = NEW.relation_id)
                !=
                (SELECT fact_id FROM fact_constituents WHERE id = NEW.fact_constituent_id)
              )
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
            BEFORE INSERT
              ON relation_constituents
                FOR EACH ROW EXECUTE PROCEDURE relation_constituent_common_fact();
        SQL
      end

      dir.down do
        # remove new trigger and function
        execute <<~SQL
          DROP TRIGGER foreign_relation_constituent ON relation_constituents
        SQL

        execute <<~SQL
          DROP FUNCTION relation_constituent_common_fact()
        SQL

        # restore old function and trigger
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
    end
  end
end
