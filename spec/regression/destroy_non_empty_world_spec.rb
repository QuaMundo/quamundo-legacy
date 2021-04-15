# frozen_string_literal: true

# FIXME: Add to world model specs
RSpec.describe World, type: :model, db_triggers: true do
  it 'destroys a world with all inventories, facts and relations' do
    world = create(:world)
    item = create(:item, world: world)
    figure = create(:figure, world: world)
    fact = create(:fact, world: world)
    fc1 = create(:fact_constituent, fact: fact, constituable: item)
    fc2 = create(:fact_constituent, fact: fact, constituable: figure)
    relation = create(:relation, fact: fact)
    _rc1 = create(:relation_constituent, relation: relation, fact_constituent: fc1, role: :subject)
    _rc2 = create(:relation_constituent, relation: relation, fact_constituent: fc2, role: :relative)

    expect { world.destroy! }.not_to raise_error
  end
end
