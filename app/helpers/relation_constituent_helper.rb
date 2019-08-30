module RelationConstituentHelper
  def self.select_options(relation_constituent)
    RelationConstituentsSelector
      .new(relation_constituent)
      .selectable_constituents.collect { |c|
      ["#{c.constituable_type}: #{c.constituable_name}", c.id]
    }
  end

  class RelationConstituentsSelector
    SQL = <<~SQL
      SELECT
        fc.*,
        i.name as constituable_name,
        i.inventory_type as constituable_type
      FROM
        relations r
      JOIN
        facts f
      ON
        f.id = r.fact_id
      JOIN
        fact_constituents fc
      ON
        fc.fact_id = f.id
      LEFT OUTER JOIN
        relation_constituents rc
      ON
        rc.fact_constituent_id = fc.id AND rc.relation_id = r.id
      JOIN
        inventories i
      ON
        i.inventory_type = fc.constituable_type
      AND
        i.inventory_id = fc.constituable_id
      WHERE
        rc.id IS NULL
      AND
        r.id = ?            -- insert param here
      ORDER BY
        i.inventory_type ASC, i.name ASC
    SQL
    
    def initialize(relation_constituent)
      @relation_id = relation_constituent.relation.id
    end

    def selectable_constituents
      @consituents ||= FactConstituent.find_by_sql([SQL, @relation_id])
    end
  end
end
