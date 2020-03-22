module FigurePedigree
  extend ActiveSupport::Concern

  included do
    def pedigree
      Pedigree.new(self.id).execute
    end
  end

  # Helper class - finds all ancestors and descendants of a given figure
  # Adds field 'degree' which represents the relation degree; positive numbers
  # are descendants, negative numbers are ancestors
  class Pedigree
    # FIXME: Avoid doubles (with non-direct ancestors)
    SQL = <<~SQL
      WITH pedigree AS (
        WITH RECURSIVE ancestor_tree(id, figure_id, ancestor_id, degree)
        AS (
          SELECT
            f.id,
            f.figure_id,
            f.ancestor_id,
            -1::bigint
          FROM figure_ancestors f
          WHERE
            f.figure_id = :figure_id                  -- param figure_id
          UNION SELECT
            a.id,
            a.figure_id,
            a.ancestor_id,
            degree - 1
          FROM figure_ancestors a
          JOIN ancestor_tree
          ON ancestor_tree.ancestor_id = a.figure_id
        ),
        descendant_tree(id, figure_id, ancestor_id, degree)
        AS (
          SELECT
            f.id,
            f.figure_id,
            f.ancestor_id,
            1::bigint
          FROM figure_ancestors f
          WHERE
            f.ancestor_id = :figure_id                  -- param figure_id
          UNION SELECT
            a.id,
            a.figure_id,
            a.ancestor_id,
            degree + 1
          FROM figure_ancestors a
          JOIN descendant_tree
          ON descendant_tree.figure_id = a.ancestor_id
        )
        SELECT
          ancestor_tree.id,
          ancestor_tree.figure_id,
          ancestor_tree.ancestor_id,
          ancestor_tree.degree
        FROM ancestor_tree
        UNION SELECT
          descendant_tree.id,
          descendant_tree.ancestor_id,
          descendant_tree.figure_id,
          descendant_tree.degree
        FROM descendant_tree
      )
      SELECT
        p.*,
        pedigree.degree
      FROM pedigree
      JOIN figures p
      ON pedigree.ancestor_id = p.id
      ORDER BY ABS(degree) ASC;
    SQL

    def initialize(figure_id)
      @figure_id = figure_id
    end

    def execute
      Figure.find_by_sql([SQL, { figure_id: @figure_id }])
    end
  end
end
