RSpec.describe 'Updating/editing a relation constituent', type: :system do
  include_context 'Session'

  let(:const)       { create(:relation_constituent, user: user) }
  let(:relation)    { const.relation }
  let(:fact)        { relation.fact }
  let(:world)       { fact.world }

  it 'updates role of an constituent' do
    visit edit_world_relation_constituent_path(
      world, const, relation_constituent: { relation_id: relation.id }
    )
    choose('relation_constituent_role_relative')
    click_button('submit')
    expect(page)
      .to have_current_path(world_fact_relation_path(world, fact, relation))
    # expect(page)
    #   .to have_selector('#relatives li a',
    #                     text: const.fact_constituent.constituable.name)
    # expect(page)
    #   .not_to have_selector('#subjects li a',
    #                         text: const.fact_constituent.constituable.name)
    # expect(relation.subjects).not_to include(const)
    expect(relation.relatives).to include(const)
  end
end
