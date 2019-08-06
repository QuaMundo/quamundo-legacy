RSpec.describe 'Adding a constituent to a fact', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_facts, user: user) }
  let(:fact)  { create(:fact, world: world) }
  let!(:item) { create(:item, world: world) }

  it 'adds constituent to a fact' do
    visit new_world_fact_fact_constituent_path(world, fact)
    fill_in('Roles', with: 'Role_A, Role_B, Role_A')
    select("Item: #{item.name}", from: 'Inventory')
    click_button('submit')
    fact.reload
    expect(page).to have_current_path(world_fact_path(world, fact))
    expect(page).to have_content(item.name)
    # expect(fact.fact_constituents.map(&:constituable)).to include(item)
    expect(fact.fact_constituents.last.constituable).to eq(item)
    expect(fact.fact_constituents.last.roles)
      .to contain_exactly('Role_A', 'Role_B')
  end

  it 'gives an error if constiuable ist not set' do
    visit new_world_fact_fact_constituent_path(world, fact)
    click_button('submit')
    expect(page).to have_selector('.alert-danger')
  end
end
