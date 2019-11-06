RSpec.describe 'relations/index', type: :view do
  include_context 'Session'
  let(:relation)  { create(:relation_with_constituents) }

  it 'shows a relation index entry' do
    render partial: 'relations/index_entry', locals: { index_entry: relation }

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{relation.name}/)
    expect(rendered)
      .to have_selector('.index_entry_description', text: /#{relation.description}/)
    expect(rendered).to match /#{relation.fact.world.name}/

    expect(rendered).to match /#{relation.subjects.count}\s+Subject/
    expect(rendered).to match /#{relation.relatives.count}\s+Relative/

    expect(rendered)
      .to have_link(href: world_fact_relation_path(
        relation.fact.world, relation.fact, relation))
    expect(rendered)
      .to have_link(href: edit_world_fact_relation_path(
        relation.fact.world, relation.fact, relation))
    expect(rendered)
      .to have_link(href: world_fact_relation_path(
        relation.fact.world, relation.fact, relation), id: /delete-.+/)
  end
end
