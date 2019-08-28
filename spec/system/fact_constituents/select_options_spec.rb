RSpec.describe 'Select options for fact constituents',
  type: :system, db_triggers: true do

  include_context 'Session'

  let(:world)   { create(:world, user: user) }
  let!(:item) { create(:item, world: world) }
  let!(:fact) { create(:fact, world: world) }
  let!(:location) { create(:location, world: world) }
  let!(:figure) { create(:figure, world: world) }
  let!(:other_fact) { create(:fact, world: world) }

  before(:example) { other_fact.fact_constituents.create(constituable: location) }

  context 'in creation form' do
    it 'does not contain facts' do
      other_fact.fact_constituents.create(constituable: item)
      visit new_world_fact_fact_constituent_path(world, fact)
      page.within('select#fact_constituent_inventory') do
        expect(page).to have_selector('option[value^="Item"]')
        expect(page).to have_selector('option[value^="Figure"]')
        expect(page).to have_selector('option[value^="Location"]')
        #expect(page).to have_selector('option[value^="Spirit"]')
        expect(page).not_to have_selector('option[value^="Fact"]')
      end
    end

    it 'does not contain allready included inventory' do
      fact.fact_constituents.create(constituable: item)
      other_fact.fact_constituents.create(constituable: item)
      visit new_world_fact_fact_constituent_path(world, fact)
      page.within('select#fact_constituent_inventory') do
        expect(page).not_to have_selector('option[value^="Item"]')
        expect(page).to have_selector('option[value^="Figure"]')
        expect(page).to have_selector('option[value^="Location"]')
        #expect(page).to have_selector('option[value^="Spirit"]')
        expect(page).not_to have_selector('option[value^="Fact"]')
      end
    end
  end

  context 'in update form' do
    before(:example) { fact.fact_constituents.create(constituable: item) }

    it 'does not contain facts' do
      visit new_world_fact_fact_constituent_path(world, fact)
      other_fact.fact_constituents.create(constituable: item)
      page.within('select#fact_constituent_inventory') do
        expect(page).not_to have_selector('option[value^="Item"]')
        expect(page).to have_selector('option[value^="Figure"]')
        expect(page).to have_selector('option[value^="Location"]')
        #expect(page).to have_selector('option[value^="Spirit"]')
        expect(page).not_to have_selector('option[value^="Fact"]')
      end
    end
  end
end
