class CheckFactConstituentsCommonWorld < ActiveRecord::Migration[6.0]
  # Ensure all constituables of a fact belong to the facts world
  def change
    reversible do |dir|
      dir.up do
        # create trigger function
        execute <<~SQL
          CREATE FUNCTION fact_constituents_common_world() RETURNS TRIGGER AS $$
            BEGIN
              IF (SELECT ((i.world_id IS NULL)
                    OR (f.world_id IS NULL)
                    OR (f.world_id != i.world_id))
                  FROM fact_constituents fc
                  LEFT JOIN facts f ON f.id = fc.fact_id
                  LEFT JOIN inventories i ON fc.constituable_id = i.inventory_id
                                          AND fc.constituable_type = i.inventory_type
                  WHERE fc.id = NEW.id)
              THEN
                  RAISE EXCEPTION 'World mismatch: constituent % % does not belong to same world as his fact',
                    NEW.constituable_type, NEW.constituable_id;
              ELSE
                  RETURN NEW;
              END IF;
            END;
          $$ language plpgsql;
        SQL

        # create trigger
        execute <<~SQL
          CREATE TRIGGER foreign_fact_constituent
            AFTER INSERT OR UPDATE OF constituable_id, constituable_type
            ON fact_constituents
              FOR EACH ROW EXECUTE PROCEDURE fact_constituents_common_world();
        SQL
      end

      dir.down do
        # drop trigger
        execute <<~SQL
          DROP TRIGGER foreign_fact_constituent ON fact_constituents;
        SQL

        # drop trigger function
        execute <<~SQL
          DROP FUNCTION fact_constituents_common_world();
        SQL
      end
    end
  end
end
