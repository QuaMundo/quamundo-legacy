# frozen_string_literal: true

module FigureAncestorHelper
  class << self
    def selectable_ancestors(figure)
      FigureAncestorSelector
        .new(figure)
        .selectable_ancestors
    end
  end

  class FigureAncestorSelector
    # rubocop:disable Rails/HelperInstanceVariable
    # FIXME: Check and refactor SQL
    # Find all figures that are not related to @figure but share the same world
    SQL = <<~SQL
      WITH excluded_ancestors AS (
        SELECT a.figure_id
        FROM figure_ancestors a
        WHERE a.ancestor_id = :figure_id            -- param figure_id
        UNION SELECT b.ancestor_id
        FROM figure_ancestors b
        WHERE b.figure_id = :figure_id              -- param figure_id
      )
      SELECT f.*
      FROM figures f
      LEFT OUTER JOIN excluded_ancestors a
      ON f.id = a.figure_id
      WHERE a.figure_id IS NULL
      AND f.id <> :figure_id                        -- param figure_id
      AND f.world_id = :world_id                    -- param world_id
      ORDER BY f.name ASC
    SQL

    def initialize(figure)
      @figure = figure
    end

    def selectable_ancestors
      if @figure.id.nil?
        @figure.world.figures.order(name: :asc)
      else
        @selectable_ancestors ||= Figure.find_by_sql(
          [SQL,
           { figure_id: @figure.id, world_id: @figure.world_id }]
        )
      end
    end
    # rubocop:enable Rails/HelperInstanceVariable
  end
end
