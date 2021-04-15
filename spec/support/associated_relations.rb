# frozen_string_literal: true

RSpec.shared_examples 'associated relations',
                      type: :system do
  # Expect `subject` and `path` to be present
  let(:fact)      { create(:fact, world: subject.world) }
  let(:relation)  { create(:relation_with_constituents, fact: fact) }

  before(:example) do
    fc = fact.fact_constituents.create(constituable: subject)
    relation.relation_constituents.create(fact_constituent: fc, role: :subject)
    refresh_materialized_views(SubjectRelativeRelation)
    visit polymorphic_path([fact.world, subject])
  end

  it 'shows relatives of the inventory' do
    expect(subject.relatives.count).to be > 1
    subject.relatives.each do |relative|
      rid = relative.fact_constituent.id
      expect(page)
        .to have_selector("[id=\"index-entry-fact_constituent-#{rid}\"]")
    end
  end

  it 'can edit a relation' do
    constituent = relation.relatives.first.fact_constituent
    click_link(id: element_id(constituent, 'edit').to_s,
               href: edit_world_fact_relation_path(fact.world, fact, relation))

    expect(page)
      .to have_current_path(
        edit_world_fact_relation_path(fact.world, fact, relation)
      )
  end

  it 'can delete a relation to an inventory' do
    relative = relation.relatives.first
    click_link(id: element_id(relative, 'delete').to_s)
    expect(page)
      .to have_current_path(
        world_fact_relation_path(fact.world, fact, relative.relation)
      )
    expect { RelationConstituent.find(relative.id) }
      .to raise_error ActiveRecord::RecordNotFound
  end
end
