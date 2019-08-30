module FactConstituentHelper
  def self.select_options(fact_constituent)
    FactConstituentsSelector
      .new(fact_constituent)
      .selectable_constituents.collect { |c|
      [
        "#{c.inventory_type}: #{c.name}",
        [c.inventory_type, c.inventory_id].join('.')
      ]
    }
  end

  class FactConstituentsSelector
    SQL = <<~SQL
      select
        i.inventory_type,
        i.inventory_id,
        i.name
      from
        inventories i
      left outer join
        fact_constituents c
      on
        i.inventory_id = c.constituable_id
        and i.inventory_type = c.constituable_type
      where
        i.world_id = ?                                       -- insert param here
      group by
        i.inventory_type,
        i.inventory_id,
        i.name
      having
        i.inventory_type in ('Figure', 'Item', 'Location', 'Concept')
        and not array_agg(c.fact_id) @> array[?]::bigint[]   -- insert param here
      order by i.inventory_type asc
    SQL

    def initialize(fact_constituent)
      @fact = fact_constituent.fact
      @world = @fact.world
    end

    def selectable_constituents
      @consituents ||= Inventory.find_by_sql([SQL, @world.id, @fact.id])
    end
  end
end
