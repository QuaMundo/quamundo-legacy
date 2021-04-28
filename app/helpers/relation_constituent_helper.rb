# frozen_string_literal: true

# FIXME: This helper needs refactoring!
module RelationConstituentHelper
  class << self
    def selectable_constituents(relation)
      # FIXME: Is it save to use a cache here?
      # ... seems there have been problems in
      # `app/helpers/fact_constituent_helper.rb`,
      # fixed in commit b67c0c5cde0504c318371ebf9f753e6cf9dc1f2b
      # (Also check additional test examples of this commit!)
      # See also redmine ticket #454
      # @cache ||= {}
      # @cache[relation_constituent] ||= RelationConstituentsSelector
      # FIXME: Commit this an write a test!
      RelationConstituentsSelector
        .new(relation)
        .selectable_constituents
    end

    # FIXME: Make this conform to app/helpers/fact_constituent_helper.rb:9
    def select_group_options(relation)
      selectable_constituents(relation).each_with_object({}) do |current, memo|
        (memo[current.constituable_type] ||= [])
          .push([current.constituable_name, current.id])
      end
    end
  end

  class RelationConstituentsSelector
    # rubocop:disable Rails/HelperInstanceVariable
    # If a relation exists (i.e. relation.id is not nil) use this query
    SQL_EDIT = <<~SQL
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

    # If relation is new (i.e. hasn't an id yet) query all fact_constituents
    # of given fact.
    SQL_NEW = <<~SQL
      SELECT
        fc.*,
        i.name as constituable_name,
        i.inventory_type as constituable_type
      FROM
        fact_constituents fc
      JOIN
        inventories i
      ON
        i.inventory_type = fc.constituable_type
      AND
        i.inventory_id = fc.constituable_id
      WHERE
        fc.fact_id = ?      -- insert param fact_id
      ORDER BY i.inventory_type ASC
    SQL

    def initialize(relation)
      @relation = relation
      if relation.id.nil?
        @param = relation.fact_id
        @sql = SQL_NEW
      else
        @param = relation.id
        @sql = SQL_EDIT
      end
    end

    def selectable_constituents
      @selectable_constituents ||= FactConstituent.find_by_sql([@sql, @param])
    end
    # rubocop:enable Rails/HelperInstanceVariable
  end
end
