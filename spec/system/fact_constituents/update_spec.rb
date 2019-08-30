RSpec.describe 'Updating/Editing a fact constituent', type: :system do
  include_context 'Session'

  let(:const) { create(:fact_constituent, user: user) }
  let(:fact)  { const.fact }
  let(:world) { fact.world }

  it 'updates a constituent' do
    visit edit_world_fact_fact_constituent_path(world, fact, const)
    fill_in('Roles', with: 'role_x, role_y')
    click_button('submit')
    expect(page).not_to have_selector('.alert-danger')
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
