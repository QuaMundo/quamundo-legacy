RSpec.describe 'concepts/index', type: :view do
  include_context 'Session'
  let(:concept)   { create(:concept) }

  it 'shows a concept index entry' do
    render partial: 'concepts/index_entry', locals: { index_entry: concept }

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{concept.name}/)
    expect(rendered)
      .to have_selector('.index_entry_description',
                        text: /#{concept.description}/)
    expect(rendered).to match /#{concept.world.name}/
    expect(rendered).to match /#{concept.facts.count}/
    expect(rendered).to match /#{concept.relatives.count}/

    expect(rendered)
      .to have_link(href: world_concept_path(concept.world, concept))
    expect(rendered)
      .to have_link(href: edit_world_concept_path(concept.world, concept))
    expect(rendered)
      .to have_link(href: world_concept_path(concept.world, concept),
                    id: /delete-.+/)
  end
end
