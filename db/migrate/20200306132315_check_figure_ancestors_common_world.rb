class CheckFigureAncestorsCommonWorld < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # create trigger function
        execute <<~SQL
          CREATE FUNCTION figure_ancestors_common_world() RETURNS TRIGGER AS $$
            BEGIN
              IF (SELECT ((f.world_id IS NULL)
                    OR (a.world_id IS NULL)
                    OR (f.world_id <> a.world_id))
                  FROM figure_ancestors fa
                  LEFT JOIN figures f ON fa.figure_id = f.id
                  LEFT JOIN figures a ON fa.ancestor_id = a.id
                  WHERE fa.id = NEW.id)
              THEN
                 RAISE EXCEPTION 'World mismatch: ancestor % does not belong to world of %',
                  NEW.ancestor_id, NEW.figure_id;
              ELSE
                RETURN NEW;
              END IF;
            END;
          $$ language plpgsql;
        SQL
        # creat trigger
        execute <<~SQL
          CREATE TRIGGER foreign_figure_ancestor
            AFTER INSERT OR UPDATE OF figure_id, ancestor_id
            ON figure_ancestors
              FOR EACH ROW EXECUTE PROCEDURE figure_ancestors_common_world();
        SQL
      end

      dir.down do
        # drop trigger
        execute <<~SQL
          DROP TRIGGER foreign_figure_ancestor ON figure_ancestors;
        SQL
        # drop trigger function
        execute <<~SQL
          DROP FUNCTION figure_ancestors_common_world();
        SQL
      end
    end
  end
end
