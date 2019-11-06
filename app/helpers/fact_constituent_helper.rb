module FactConstituentHelper
  class << self
    def selectable_constituents(fact)
      FactConstituentsSelector
        .new(fact)
        .selectable_constituents
    end

    def select_group_options(fact)
      selectable_constituents(fact).inject({}) do |memo, current|
        (memo[current.inventory_type] ||= [])
          .push([current.name, current.type_id])
        memo
      end
    end
  end

  class FactConstituentsSelector
    SQL = <<~SQL
      SELECT
        i.inventory_type,
        i.inventory_id,
        i.name
      FROM
        inventories i
      LEFT OUTER JOIN
        fact_constituents c
      ON
        i.inventory_id = c.constituable_id
        AND i.inventory_type = c.constituable_type
      WHERE
        i.world_id = ?                                  -- insert world_id here
      GROUP BY
        i.inventory_type,
        i.inventory_id,
        i.name
      HAVING
        NOT array_agg(c.fact_id) @> array[?]::bigint[]  -- insert fact_id here
      ORDER BY i.inventory_type ASC
    SQL

    def initialize(fact)
      @fact = fact
    end

    def selectable_constituents
      @constituents ||= Inventory.find_by_sql([SQL, @fact.world.id, @fact.id])
    end
  end
end
