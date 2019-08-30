class AddFactReferenceToRelations < ActiveRecord::Migration[6.0]
  def change
    # add reference to fact
    add_reference :relations, :fact

    reversible do |dir|
      dir.up do
        # update relations
        Relation.all.each do |r|
          if r.relation_constituents.empty?
            # delete all relations without constituents
            p "Destroying relation '#{r.name}' since it has no constituents."
            r.destroy
          else
            # set all relations to appropriate fact
            # (since it is a somehow circular association, the fact can be reached
            # via relation_constituents
            fact = r.relation_constituents.first.fact_constituent.fact
            p "Updating relation '#{r.name}', set fact to '#{fact.name}'."
            r.update(fact_id: fact.id)
          end
        end
      end
    end

    # add not null constraint
    change_column_null :relations, :fact_id, false
  end
end
