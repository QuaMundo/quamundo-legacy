RSpec.describe 'Updating/Editing a fact constituent', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_facts, user: user) }
  let(:fact)  { world.facts.first }
  let(:const) { fact.fact_constituents.first }

  it 'updates a constituent' do
    visit edit_world_fact_fact_constituent_path(world, fact, const)
    fill_in('Roles', with: 'role_x, role_y')
    click_button('submit')
    expect(page).not_to have_selector('.alert-danger')
    expect(page).to be_i18n_ready
    expect(page).to have_current_path(world_fact_path(world, fact))
    expect(page).to have_content('role_x')
    expect(page).to have_content('role_y')
  end

  it 'removes roles when giving empty roles field' do
    const.roles = ['role']
    const.save
    visit edit_world_fact_fact_constituent_path(world, fact, const)
    fill_in('Roles', with: nil)
    click_button
    const.reload
    expect(const.roles).to eq([])
  end
end
