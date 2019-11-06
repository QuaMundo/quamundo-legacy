RSpec.describe 'Adding a constituent to a fact', type: :system do
  include_context 'Session'

  let(:fact)  { create(:fact, user: user) }
  let(:world) { fact.world }

  context 'with available constituents' do
    let!(:item)  { create(:item, world: world) }

    it 'adds constituent to a fact', db_triggers: true do
      visit new_world_fact_fact_constituent_path(world, fact)
      fill_in('Roles', with: 'Role_A, Role_B, Role_A')
      select("#{item.name}", from: 'fact_constituent_constituable')
      click_button('submit')
      fact.reload
      expect(page).to have_current_path(world_fact_path(world, fact))
      expect(page).to have_content(item.name)
      # expect(fact.fact_constituents.map(&:constituable)).to include(item)
      expect(fact.fact_constituents.last.constituable).to eq(item)
      expect(fact.fact_constituents.last.roles)
        .to contain_exactly('Role_A', 'Role_B')
    end

    it 'does not provide already associated constituent again when creating new',
      db_triggers: true do
      item_2 = create(:item, world: world)
      visit new_world_fact_fact_constituent_path(world, fact)
      select("#{item.name}", from: 'fact_constituent_constituable')
      click_button('submit')
      visit new_world_fact_fact_constituent_path(world, fact)
      expect(page)
        .not_to have_selector("option[value=\"Item.#{item.id}\"]")
    end

    it 'gives an error if constituable ist not set', db_triggers: true do
      visit new_world_fact_fact_constituent_path(world, fact)
      click_button('submit')
      expect(page).to have_selector('.alert-danger')
    end
  end

  context 'without available constituents' do
    it 'redirects to fact show view with notice', db_triggers: true do
      visit new_world_fact_fact_constituent_path(world, fact)
      expect(page).to have_current_path(world_fact_path(world, fact))
      expect(page).to have_selector('.alert.alert-info')
    end
  end
end
