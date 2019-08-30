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
      inventory = relative.fact_constituent.constituable
      expect(page).to have_content(inventory.name)
      expect(page).to have_content(inventory.description)
      expect(page).to have_content(relative.name)
      expect(page)
        .to have_link(href: polymorphic_path([fact.world, inventory]))
      expect(page)
        .to have_link(
          href: edit_world_fact_relation_path(fact.world, fact, relation)
      )
      expect(page)
        .to have_link(
          title: 'destroy',
          href: world_relation_constituent_path(fact.world, relative.relative)
      )
    end
  end

  it 'can edit a relation' do
    relative = relation.relatives.first
    page.find("##{element_id(relative)}")
      .click_link(
        href: edit_world_fact_relation_path(fact.world, fact, relation)
    )
    expect(page)
      .to have_current_path(
        edit_world_fact_relation_path(fact.world, fact, relation)
    )
  end

  it 'can delete a relation to an inventory' do
    relative = relation.relatives.first
    page.find("##{element_id(relative)}")
      .click_link(title: 'destroy',
                  href: world_relation_constituent_path(fact.world, relative))
    expect(page)
      .to have_current_path(
        world_fact_relation_path(fact.world, fact, relative.relation)
    )
    # FIXME: Put this to deletion_spec!
    expect { RelationConstituent.find(relative.id) }
      .to raise_error ActiveRecord::RecordNotFound
  end
end
