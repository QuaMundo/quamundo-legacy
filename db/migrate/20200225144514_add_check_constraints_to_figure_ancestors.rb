class AddCheckConstraintsToFigureAncestors < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE figure_ancestors
          ADD CONSTRAINT no_figure_ancestors_self_references
          CHECK (figure_id <> ancestor_id);
        SQL
      end

      dir.down do
        execute <<~SQL
          ALTER TABLE figure_ancestors
          DROP CONSTRAINT no_figure_ancestors_self_references;
        SQL
      end
    end
  end
end
